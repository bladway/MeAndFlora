package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class StringDto {

    public StringDto(String string) {
        this.string = string;
    }

    private String string;

}