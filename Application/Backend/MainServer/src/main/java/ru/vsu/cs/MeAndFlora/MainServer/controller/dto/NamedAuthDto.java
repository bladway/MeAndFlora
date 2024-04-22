package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class NamedAuthDto {

    private String login;
    private String password;
    private String ipAddress;

}
