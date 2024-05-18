package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class LoginDto {

    public LoginDto(String login) {
        this.login = login;
    }

    private String login;

}