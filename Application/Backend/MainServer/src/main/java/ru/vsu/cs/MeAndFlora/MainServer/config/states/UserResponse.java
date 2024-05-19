package ru.vsu.cs.MeAndFlora.MainServer.config.states;

import lombok.Getter;

@Getter
public enum UserResponse {

    YES("yes"),
    NO("no"),
    UNKNOWN("unknown");

    private final String name;

    UserResponse(String name) {
        this.name = name;
    }

}
