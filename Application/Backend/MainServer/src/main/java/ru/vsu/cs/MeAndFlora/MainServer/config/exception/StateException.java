package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

public class StateException extends CustomRuntimeException {

    public StateException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
