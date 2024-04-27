package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

import java.time.OffsetDateTime;

public class AuthException extends CustomRuntimeException {

    public AuthException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
