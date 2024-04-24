package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class NamedAuthDto {

    public NamedAuthDto(String login, String password, String ipAddress) {
        this.login = login;
        this.password = password;
        this.ipAddress = ipAddress;
    }

    private String login;
    private String password;
    private String ipAddress;

}
