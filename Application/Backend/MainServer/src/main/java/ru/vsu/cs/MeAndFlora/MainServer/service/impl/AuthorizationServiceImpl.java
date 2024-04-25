package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.util.Optional;
import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.AuthPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

@Service
@RequiredArgsConstructor
public class AuthorizationServiceImpl implements AuthorizationService {

    /*public AuthorizationServiceImpl(
        MafUserRepository mafUserRepository, 
        USessionRepository uSessionRepository,
        JwtUtil jwtUtil,
        AuthPropertiesConfig authPropertiesConfig
    ) {
        this.mafUserRepository = mafUserRepository;
        this.uSessionRepository = uSessionRepository;
        this.jwtUtil = jwtUtil;
        this.authPropertiesConfig = authPropertiesConfig;
    }*/

    private final MafUserRepository mafUserRepository;
    
    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private final AuthPropertiesConfig authPropertiesConfig;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private void validateLogin(String login) {
        if (login.length() < 6 || login.length() > 25) {
            throw new AuthException(
                authPropertiesConfig.getBadlogin(), 
            "login does not match expected length: 6 - 25"
            );
        }
    }

    private void validatePassword(String password) {
        if (password.length() < 6 || password.length() > 25) {
            throw new AuthException(
                authPropertiesConfig.getBadpassword(),
                "password does not match expected length: 6 - 25"    
            );
        }
    }

    private void validateIpAddress(String ipAddress) {
        if (!InetAddressValidator.getInstance().isValidInet4Address(ipAddress)) {
            throw new AuthException(
                authPropertiesConfig.getBadip(),
                "ip address does not match expected template: 0-255.0-255.0-255.0-255"
            );
        }
    }

    @Override
    public DiJwtDto register(String login, String password, String ipAddress) {
        validateLogin(login);

        mafUserRepository.findById(login).ifPresent(
            mafUser -> {
                throw new AuthException(
                    authPropertiesConfig.getDoublelogin(),
                    "such login exists in the database"
                );
            }
        );

        validatePassword(password);
        validateIpAddress(ipAddress);

        MafUser user = mafUserRepository.save(new MafUser(login, password, UserRole.USER.getName()));

        USession session = uSessionRepository.save(new USession(ipAddress, "", "", user));

        session.setJwt(jwtUtil.generateToken(session.getSessionId()));
        session.setJwtR(jwtUtil.generateRToken(session.getSessionId()));

        uSessionRepository.save(session);

        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public DiJwtDto login(String login, String password, String ipAddress) {
        validateLogin(login);
        validatePassword(password);
        validateIpAddress(ipAddress);

        Optional<MafUser> ifuser = mafUserRepository.findById(login);

        if (!ifuser.isPresent()) {
            throw new AuthException(
                authPropertiesConfig.getUsrnotfound(),
                "this user has not found in the database"
            );
        }

        MafUser user = ifuser.get();

        USession session = uSessionRepository.save(new USession(ipAddress, "", "", user));

        session.setJwt(jwtUtil.generateToken(session.getSessionId()));
        session.setJwtR(jwtUtil.generateRToken(session.getSessionId()));

        uSessionRepository.save(session);

        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public DiJwtDto anonymousLogin(String ipAddress) {
        validateIpAddress(ipAddress);

        USession session = uSessionRepository.save(new USession(ipAddress, "", "", null));

        session.setJwt(jwtUtil.generateToken(session.getSessionId()));
        session.setJwtR(jwtUtil.generateRToken(session.getSessionId()));
        
        uSessionRepository.save(session);
        
        return new DiJwtDto(session.getJwt(), session.getJwtR());
    }

    @Override
    public DiJwtDto refresh(String jwtR) {

        Optional<USession> ifsession = uSessionRepository.findByJwtR(jwtR);

        if (!ifsession.isPresent()) {
            throw new JwtException(
                jwtPropertiesConfig.getBadjwtr(),
                "provided refresh jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtRExpired(session.getCreatedTime())) {
            throw new JwtException(
                jwtPropertiesConfig.getExpiredr(),
                "refresh jwt lifetime has ended, relogin, please"
            );
        }

        USession newSession = uSessionRepository.save(new USession(session.getIpAddress(), "", "", session.getUser()));
        
        newSession.setJwt(jwtUtil.generateToken(session.getSessionId()));
        newSession.setJwtR(jwtUtil.generateRToken(session.getSessionId()));
        
        uSessionRepository.save(newSession);
        
        return new DiJwtDto(newSession.getJwt(), session.getJwtR());
    }

    /*@Override
    public String userExit(String token) {
        Optional<USession> sessionToClose = uSessionRepository.findByJwtAndIsClosed(token, false);

        if (!sessionToClose.isPresent()) {
            throw new AuthException(
                authPropertiesConfig.getSessionidproblem(),
                "session does not exists in the database"
            );
        } else if (sessionToClose.get().isClosed()) {
            throw new AuthException(
                authPropertiesConfig.getSessionidproblem(), 
                "session has already closed"
            );
        }
        
        USession lastSession = sessionToClose.get();
        lastSession.setClosed(true);
        
        return uSessionRepository.save(lastSession).getJwt();
    }*/

}
