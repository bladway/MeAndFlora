package ru.vsu.cs.MeAndFlora.MainServer.dto;

import java.time.OffsetDateTime;
import lombok.Data;

@Data
public class ApplicationExceptionDto {

    public ApplicationExceptionDto(String shortMessage, String message, OffsetDateTime timestamp) {
        this.shortMessage = shortMessage;
        this.message = message;
        this.timestamp = timestamp;
    }

    private String shortMessage;
    private String message;
    private OffsetDateTime timestamp;

}
