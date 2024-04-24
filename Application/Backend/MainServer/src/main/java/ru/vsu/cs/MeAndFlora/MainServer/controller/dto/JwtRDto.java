package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class JwtRDto {

    public JwtRDto(String jwtR) {
        this.jwtR = jwtR;
    }

    private String jwtR;
    
}
