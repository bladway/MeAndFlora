package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class LongDto {

    public LongDto(Long number) {
        this.number = number;
    }

    private Long number;

}