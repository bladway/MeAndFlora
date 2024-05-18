package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.AccountChangesDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LoginDto;

public interface AuthorizationService {

    DiJwtDto register(String login, String password, String ipAddress);

    DiJwtDto login(String login, String password, String ipAddress);

    DiJwtDto anonymousLogin(String ipAddress);

    DiJwtDto refresh(String jwtR);

    LoginDto change(String jwt, String newLogin, String newPassword, String oldPassword);

}
