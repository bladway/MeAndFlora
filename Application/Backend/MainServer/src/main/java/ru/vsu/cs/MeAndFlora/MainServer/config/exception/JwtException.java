package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

public class JwtException extends CustomRuntimeException {

    public JwtException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
