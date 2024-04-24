package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class DiJwtDto {

    public DiJwtDto(String jwt, String jwtR) {
        this.jwt = jwt;
        this.jwtR = jwtR;
    }

    private String jwt;
    private String jwtR;
    
}
