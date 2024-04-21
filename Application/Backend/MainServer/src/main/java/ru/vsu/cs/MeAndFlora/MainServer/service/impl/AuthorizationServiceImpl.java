package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.util.Optional;

import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.stereotype.Service;

import ru.vsu.cs.MeAndFlora.MainServer.config.AuthPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

@Service
public class AuthorizationServiceImpl implements AuthorizationService {

    public AuthorizationServiceImpl(
        MafUserRepository mafUserRepository, 
        USessionRepository uSessionRepository,
        AuthPropertiesConfig authPropertiesConfig
    ) {
        this.mafUserRepository = mafUserRepository;
        this.uSessionRepository = uSessionRepository;
        this.authPropertiesConfig = authPropertiesConfig;
    }

    private final MafUserRepository mafUserRepository;
    
    private final USessionRepository uSessionRepository;

    private final AuthPropertiesConfig authPropertiesConfig;

    private void loginValidation(String login) {
        if (login.length() < 6 || login.length() > 25) {
            throw new ApplicationException(
                authPropertiesConfig.getBadlogin(), 
            "login does not match expected length: 6 - 25"
            );
        }
    }

    private void passwordValidation(String password) {
        if (password.length() < 6 || password.length() > 25) {
            throw new ApplicationException(
                authPropertiesConfig.getBadpassword(),
                "password does not match expected length: 6 - 25"    
            );
        }
    }

    private void ipAddressValidation(String ipAddress) {
        if (!InetAddressValidator.getInstance().isValidInet4Address(ipAddress)) {
            throw new ApplicationException(
                authPropertiesConfig.getBadip(),
                "ip address does not match expected template: 0-255.0-255.0-255.0-255"
            );
        }
    }

    @Override
    public Long register(String login, String password, String ipAddress) {
        loginValidation(login);
        mafUserRepository.findById(login).ifPresent(
            mafUser -> {
                throw new ApplicationException(
                    authPropertiesConfig.getDoublelogin(),
                    "such login exists in the database"
                );
            }
        );
        passwordValidation(password);
        ipAddressValidation(ipAddress);
        MafUser user = mafUserRepository.save(new MafUser(login, password, false, false));
        return uSessionRepository.save(new USession(user, ipAddress, false)).getSessionId();
    }

    @Override
    public Long login(String login, String password, String ipAddress) {
        loginValidation(login);
        passwordValidation(password);
        ipAddressValidation(ipAddress);
        Optional<MafUser> user = mafUserRepository.findById(login);
        if (!user.isPresent()) {
            throw new ApplicationException(
                authPropertiesConfig.getUsrnotfound(),
                "this user has not found in the database"
            );
        }
        return uSessionRepository.save(new USession(user.get(), ipAddress, false)).getSessionId();
    }

    @Override
    public Long anonymusLogin(String ipAddress) {
        ipAddressValidation(ipAddress);
        return uSessionRepository.save(new USession(null, ipAddress, false)).getSessionId();
    }

    @Override
    public Long userExit(Long sessionId) {
        Optional<USession> sessionToClose = uSessionRepository.findById(sessionId);
        if (!sessionToClose.isPresent() || sessionToClose.get().isClosed()) {
            throw new ApplicationException(
                authPropertiesConfig.getSessionidproblem(),
                "session has already closed or does not exists in the database"
            );
        }
        USession lastSession = sessionToClose.get();
        lastSession.setClosed(true);
        return uSessionRepository.save(lastSession).getSessionId();
    }

}
