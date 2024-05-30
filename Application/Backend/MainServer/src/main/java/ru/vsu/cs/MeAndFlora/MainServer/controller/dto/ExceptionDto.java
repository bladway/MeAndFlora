package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

@Data
@NoArgsConstructor
public class ExceptionDto {

    public ExceptionDto(String shortMessage, String message, OffsetDateTime timestamp) {
        this.shortMessage = shortMessage;
        this.message = message;
        this.timestamp = timestamp.withOffsetSameInstant(ZoneOffset.ofHours(3));
        System.out.println(OffsetDateTime.now());
    }

    private String shortMessage;
    private String message;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime timestamp;

}
