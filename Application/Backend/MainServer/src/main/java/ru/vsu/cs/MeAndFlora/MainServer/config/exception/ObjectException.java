package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

public class ObjectException extends CustomRuntimeException {

    public ObjectException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
