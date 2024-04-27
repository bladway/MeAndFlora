package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

public class AuthException extends CustomRuntimeException {

    public AuthException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
