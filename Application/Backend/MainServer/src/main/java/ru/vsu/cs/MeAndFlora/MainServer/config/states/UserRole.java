package ru.vsu.cs.MeAndFlora.MainServer.config.states;

import lombok.Getter;

@Getter
public enum UserRole {

    USER("user"),
    ADMIN("admin"),
    BOTANIST("botanist");

    private final String name;

    UserRole(String name) {
        this.name = name;
    }

}
