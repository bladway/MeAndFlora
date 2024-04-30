package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UnnamedAuthDto {

    public UnnamedAuthDto(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    private String ipAddress;

}
