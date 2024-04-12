package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.util.Optional;

import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import ru.vsu.cs.MeAndFlora.MainServer.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

@Service
public class AuthorizationServiceImpl implements AuthorizationService {

    public AuthorizationServiceImpl(MafUserRepository mafUserRepository, USessionRepository uSessionRepository) {
        this.mafUserRepository = mafUserRepository;
        this.uSessionRepository = uSessionRepository;
    }

    private final MafUserRepository mafUserRepository;
    
    private final USessionRepository uSessionRepository;

    @Value("${spring.error-messages.badlogin}")
    private String badlogin;

    @Value("${spring.error-messages.badpassword}")
    private String badpassword;

    @Value("${spring.error-messages.badip}")
    private String badip;

    @Value("${spring.error-messages.usrnotfound}")
    private String usrnotfound;

    @Value("${spring.error-messages.sessionidproblem}")
    private String sessionidproblem;

    @Value("${spring.error-messages.doublelogin}")
    private String doublelogin;

    private void loginValidation(String login) {
        if (login.length() < 6 || login.length() > 25) {
            throw new ApplicationException(badlogin);
        }
    }

    private void passwordValidation(String password) {
        if (password.length() < 6 || password.length() > 25) {
            throw new ApplicationException(badpassword);
        }
    }

    private void ipAddressValidation(String ipAddress) {
        if (!InetAddressValidator.getInstance().isValidInet4Address(ipAddress)) {
            throw new ApplicationException(badip);
        }
    }

    @Override
    public Long register(String login, String password, String ipAddress) {
        loginValidation(login);
        mafUserRepository.findById(login).ifPresent(
            mafUser -> {throw new ApplicationException(doublelogin);}
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
            throw new ApplicationException(usrnotfound);
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
            throw new ApplicationException(sessionidproblem);
        }
        USession lastSession = sessionToClose.get();
        lastSession.setClosed(true);
        return uSessionRepository.save(lastSession).getSessionId();
    }

}
