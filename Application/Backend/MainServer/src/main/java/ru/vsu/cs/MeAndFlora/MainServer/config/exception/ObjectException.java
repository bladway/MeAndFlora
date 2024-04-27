package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

import java.time.OffsetDateTime;

public class ObjectException extends CustomRuntimeException {

    public ObjectException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
