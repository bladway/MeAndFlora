package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class JwtDto {

    public JwtDto(String token) {
        this.token = token;
    }

    private String token;
    
}
