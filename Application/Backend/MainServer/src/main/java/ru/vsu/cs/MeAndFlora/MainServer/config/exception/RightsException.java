package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

public class RightsException extends CustomRuntimeException {

    public RightsException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
