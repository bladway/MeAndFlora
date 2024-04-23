package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class GetFloraDto {
    
    private String token;
    private String name;

}
