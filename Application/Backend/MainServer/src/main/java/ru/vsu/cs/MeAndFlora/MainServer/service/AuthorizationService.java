package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;

public interface AuthorizationService {

    DiJwtDto register(String login, String password, String ipAddress);

    DiJwtDto login(String login, String password, String ipAddress);

    DiJwtDto anonymousLogin(String ipAddress);

    DiJwtDto refresh(String jwtR);

    StringDto change(String jwt, String newLogin, String newPassword, String oldPassword);

}
