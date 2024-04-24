package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;

@Data
public class UnnamedAuthDto {
    
    public UnnamedAuthDto(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    private String ipAddress;
    
}
