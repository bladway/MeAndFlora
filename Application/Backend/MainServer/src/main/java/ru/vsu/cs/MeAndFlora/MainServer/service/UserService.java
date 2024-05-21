package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UserInfoDto;

public interface UserService {

    DiJwtDto register(String login, String password, String ipAddress);

    DiJwtDto login(String login, String password, String ipAddress);

    DiJwtDto anonymousLogin(String ipAddress);

    DiJwtDto refresh(String jwtR);

    StringDto change(String jwt, String newLogin, String newPassword, String oldPassword);

    StringDto createUser(String jwt, String login, String password, String role);

    StringDto deleteUser(String jwt, String login);

    UserInfoDto getUserInfo(String jwt);

}
