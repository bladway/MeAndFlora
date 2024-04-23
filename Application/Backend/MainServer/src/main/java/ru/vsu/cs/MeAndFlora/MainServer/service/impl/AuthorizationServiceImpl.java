package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.util.Optional;

import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.AuthPropertiesConfig;
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
    public String register(String login, String password, String ipAddress) {
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

        MafUser user = mafUserRepository.save(new MafUser(login, password, false, false));

        USession session = uSessionRepository.save(new USession(user, ipAddress, false, ""));
        session.setJwt(jwtUtil.generateToken(session.getSessionId()));
        return uSessionRepository.save(session).getJwt();
    }

    @Override
    public String login(String login, String password, String ipAddress) {
        validateLogin(login);
        validatePassword(password);
        validateIpAddress(ipAddress);
        Optional<MafUser> user = mafUserRepository.findById(login);
        if (!user.isPresent()) {
            throw new AuthException(
                authPropertiesConfig.getUsrnotfound(),
                "this user has not found in the database"
            );
        }
        USession session = uSessionRepository.save(new USession(user.get(), ipAddress, false, ""));
        session.setJwt(jwtUtil.generateToken(session.getSessionId()));
        return uSessionRepository.save(session).getJwt();
    }

    @Override
    public String anonymousLogin(String ipAddress) {
        validateIpAddress(ipAddress);
        return uSessionRepository.save(new USession(null, ipAddress, false, "")).getJwt();
    }

    @Override
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
    }

}
