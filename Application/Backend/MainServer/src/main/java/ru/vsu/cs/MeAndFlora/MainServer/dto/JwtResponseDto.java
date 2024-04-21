package ru.vsu.cs.MeAndFlora.MainServer.dto;

import lombok.Data;

@Data
public class JwtResponseDto {

    public JwtResponseDto(String token) {
        this.token = token;
    }

    private String token;
    
}
