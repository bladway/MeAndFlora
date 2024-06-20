package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

import lombok.Getter;

import java.time.OffsetDateTime;

@Getter
public class CustomRuntimeException extends RuntimeException {

    public CustomRuntimeException(String shortmessage, String message) {
        super(message);
        this.shortMessage = shortmessage;
        this.timestamp = OffsetDateTime.now();
    }

    protected String shortMessage;

    protected OffsetDateTime timestamp;

}
