package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class StringsDto {

    public StringsDto(List<String> strings) {
        this.strings = strings;
    }

    private List<String> strings;

}
