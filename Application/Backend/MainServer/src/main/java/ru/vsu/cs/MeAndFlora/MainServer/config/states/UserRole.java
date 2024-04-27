package ru.vsu.cs.MeAndFlora.MainServer.config.states;

public enum UserRole {

    USER("user"),
    ADMIN("admin"),
    BOTANIST("botanist");

    private String name;

    public String getName() {
        return name;
    }

    UserRole(String name) {
        this.name = name;
    }

}
