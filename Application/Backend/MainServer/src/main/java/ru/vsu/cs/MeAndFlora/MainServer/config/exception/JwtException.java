package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

import java.time.OffsetDateTime;

public class JwtException extends CustomRuntimeException {

    public JwtException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
