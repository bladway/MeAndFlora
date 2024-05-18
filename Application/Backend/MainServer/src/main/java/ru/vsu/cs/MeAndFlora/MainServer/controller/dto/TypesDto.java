package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class TypesDto {

    public TypesDto(List<String> types) {
        this.types = types;
    }

    private List<String> types;

}
