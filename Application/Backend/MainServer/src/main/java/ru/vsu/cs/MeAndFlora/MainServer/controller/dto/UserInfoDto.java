package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserInfoDto {

    public UserInfoDto(String login, String role) {
        this.login = login;
        this.role = role;
    }

    private String login;
    private String role;

}
