package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserDto {

    public UserDto(String login, String password, String role) {
        this.login = login;
        this.password = password;
        this.role = role;
    }

    private String login;
    private String password;
    private String role;

}
