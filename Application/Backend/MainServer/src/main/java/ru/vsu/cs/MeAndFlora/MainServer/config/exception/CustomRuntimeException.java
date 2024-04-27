package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

import java.time.OffsetDateTime;

public class CustomRuntimeException extends RuntimeException {

    public CustomRuntimeException(String shortmessage, String message) {
        super(message);
        this.shortMessage = shortmessage;
        this.timestamp = OffsetDateTime.now();
    }

    protected String shortMessage;

    protected OffsetDateTime timestamp;

    public String getShortMessage() {
        return shortMessage;
    }

    public OffsetDateTime getTimestamp() {
        return timestamp;
    }

}
