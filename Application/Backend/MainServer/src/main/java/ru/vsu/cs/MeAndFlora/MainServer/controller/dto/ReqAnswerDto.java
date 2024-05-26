package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ReqAnswerDto {

    public ReqAnswerDto(Long requestId, FloraDto floraDto) {
        this.requestId = requestId;
        this.floraDto = floraDto;
    }

    private Long requestId;
    private FloraDto floraDto;

}
