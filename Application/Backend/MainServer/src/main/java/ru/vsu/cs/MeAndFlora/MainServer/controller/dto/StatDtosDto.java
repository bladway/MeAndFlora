package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class StatDtosDto {

    public StatDtosDto(List<StatDto> statDtoList) {
        this.statDtoList = statDtoList;
    }

    private List<StatDto> statDtoList;

}
