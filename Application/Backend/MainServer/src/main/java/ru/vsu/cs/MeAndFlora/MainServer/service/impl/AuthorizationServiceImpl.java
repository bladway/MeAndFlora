package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.util.List;
import java.util.Optional;

import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

@AllArgsConstructor
@Service
public class AuthorizationServiceImpl implements AuthorizationService {

    private final MafUserRepository mafUserRepository;
    
    private final USessionRepository uSessionRepository;

    private void loginValidation(String login) {
        mafUserRepository.findById(login).ifPresent(
            mafUser -> {throw new ApplicationException("doublelogin");}
        );
        if (login.length() < 6 || login.length() > 25) {
            throw new ApplicationException("badlogin");
        }
    }

    private static void passwordValidation(String password) {
        if (password.length() < 6 || password.length() > 25) {
            throw new ApplicationException("badpassword");
        }
    }

    private static void ipAddressValidation(String ipAddress) {
        if (!InetAddressValidator.getInstance().isValidInet4Address(ipAddress)) {
            throw new ApplicationException("badip");
        }
    }

    @Override
    public void register(String login, String password, String ipAddress) {
        loginValidation(login);
        passwordValidation(password);
        ipAddressValidation(ipAddress);
        MafUser user = mafUserRepository.save(new MafUser(login, password, false, false));
        uSessionRepository.save(new USession(user, ipAddress, false));
    }

    @Override
    public void login(String login, String password, String ipAddress) {
        loginValidation(login);
        passwordValidation(password);
        ipAddressValidation(ipAddress);
        Optional<MafUser> user = mafUserRepository.findById(login);
        if (!user.isPresent()) {
            throw new ApplicationException("usrnotfound");
        }
        uSessionRepository.save(new USession(user.get(), ipAddress, false));
    }

    @Override
    public void anonymusLogin(String ipAddress) {
        ipAddressValidation(ipAddress);
        uSessionRepository.save(new USession(null, ipAddress, false));
    }

    @Override
    public void userExit(String ipAddress) {
        ipAddressValidation(ipAddress);
        List<USession> sessionToClose = uSessionRepository.findByIpAddressAndIsClosed(ipAddress, false);
        if (sessionToClose.size() != 1) {
            throw new ApplicationException("dbintegrityviolation");
        }
        USession lastSession = sessionToClose.get(0);
        lastSession.setClosed(true);
        uSessionRepository.save(lastSession);
    }

}
