package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

import java.time.OffsetDateTime;

public class RightsException extends CustomRuntimeException {

    public RightsException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
