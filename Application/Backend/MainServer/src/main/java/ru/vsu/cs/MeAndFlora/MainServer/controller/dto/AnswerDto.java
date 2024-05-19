package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AnswerDto {

    public AnswerDto(Long requestId, String answer) {
        this.requestId = requestId;
        this.answer = answer;
    }

    private Long requestId;
    private String answer;

}
