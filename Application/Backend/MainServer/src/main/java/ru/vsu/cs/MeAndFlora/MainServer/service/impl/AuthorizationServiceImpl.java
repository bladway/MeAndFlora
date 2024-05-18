package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.stereotype.Service;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.InputException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.AuthPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.RightsPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthorizationServiceImpl implements AuthorizationService {

    private final MafUserRepository mafUserRepository;

    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private final AuthPropertiesConfig authPropertiesConfig;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private final ObjectPropertiesConfig objectPropertiesConfig;
    private final RightsPropertiesConfig rightsPropertiesConfig;

    private void validateLogin(String login) {
        if (login.length() < 6 || login.length() > 25) {
            throw new AuthException(
                    authPropertiesConfig.getBadlogin(),
                    "login does not match expected length: 6 - 25"
            );
        }
    }

    private void validateLoginDuplication(String login) {
        mafUserRepository.findByLogin(login).ifPresent(
                mafUser -> {
                    throw new AuthException(
                            authPropertiesConfig.getDoublelogin(),
                            "such login exists in the database"
                    );
                }
        );
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
        validatePassword(password);
        validateIpAddress(ipAddress);
        validateLoginDuplication(login);

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

        Optional<MafUser> ifuser = mafUserRepository.findByLogin(login);

        if (ifuser.isEmpty()) {
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

        if (ifsession.isEmpty()) {
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

        newSession.setJwt(jwtUtil.generateToken(newSession.getSessionId()));
        newSession.setJwtR(jwtUtil.generateRToken(newSession.getSessionId()));

        uSessionRepository.save(newSession);

        return new DiJwtDto(newSession.getJwt(), newSession.getJwtR());
    }

    @Override
    public StringDto change(String jwt, String newLogin, String newPassword, String oldPassword) {
        boolean changeLogin = false;
        boolean changePassword = false;
        validatePassword(oldPassword);
        if (newLogin != null) {
            validateLogin(newLogin);
            changeLogin = true;
        }
        if (newPassword != null) {
            validatePassword(newPassword);
            changePassword = true;
        }
        if (!(changeLogin || changePassword)) {
            throw new InputException(
                    objectPropertiesConfig.getChangeisnull(),
                    "provide at least one: newLogin or newPassword"
            );
        }

        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.USER.getName()))) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "only user can change account data"
            );
        }

        MafUser user = session.getUser();

        if (!user.getPassword().equals(oldPassword)) {
            throw new AuthException(
                    authPropertiesConfig.getBadpassword(),
                    "provided old password is wrong"
            );
        }

        if (changeLogin) {
            user.setLogin(newLogin);
        }
        if (changePassword) {
            user.setPassword(newPassword);
        }

        user = mafUserRepository.save(user);

        return new StringDto(user.getLogin());
    }

}
