package ru.vsu.cs.MeAndFlora.MainServer.dto;

import lombok.Data;

@Data
public class NamedAuthDto {
    private String login;
    private String password;
    private String ipAddress;
}
