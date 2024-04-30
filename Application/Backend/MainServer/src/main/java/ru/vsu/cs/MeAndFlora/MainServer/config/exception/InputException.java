package ru.vsu.cs.MeAndFlora.MainServer.config.exception;

public class InputException extends CustomRuntimeException {

    public InputException(String shortmessage, String message) {
        super(shortmessage, message);
    }

}
