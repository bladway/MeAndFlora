package ru.vsu.cs.MeAndFlora.MainServer.exception;

public class ApplicationException extends RuntimeException {
    public ApplicationException(String message) {
        super(message);
    }
}
