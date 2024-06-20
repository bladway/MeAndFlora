package ru.vsu.cs.MeAndFlora.MainServer.config.states;

import lombok.Getter;

@Getter
public enum ProcRequestStatus {

    NEURAL_PROC("neuralProc"),
    USER_PROC("userProc"),
    BOTANIST_PROC("botanistProc"),
    SAVED("saved"),
    PUBLISHED("published"),
    BAD("bad");

    private final String name;

    ProcRequestStatus(String name) {
        this.name = name;
    }

}
