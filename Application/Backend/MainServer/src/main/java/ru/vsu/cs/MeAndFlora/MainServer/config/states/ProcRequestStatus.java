package ru.vsu.cs.MeAndFlora.MainServer.config.states;

public enum ProcRequestStatus {

    USER_PROC("userProc"),
    BOTANIST_PROC("botanistProc"),
    NEURAL_PROC("neuralProc"),
    SAVED("saved"),
    PUBLISHED("published"),
    BAD("bad");

    private String name;

    public String getName() {
        return name;
    }

    ProcRequestStatus(String name) {
        this.name = name;
    }

}
