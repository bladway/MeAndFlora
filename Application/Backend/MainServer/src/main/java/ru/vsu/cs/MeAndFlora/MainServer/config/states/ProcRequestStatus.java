package ru.vsu.cs.MeAndFlora.MainServer.config.states;

import lombok.Getter;

@Getter
public enum ProcRequestStatus {

    USER_PROC("userProc"),
    BOTANIST_PROC("botanistProc"),
    NEURAL_PROC("neuralProc"),
    SAVED("saved"),
    PUBLISHED("published"),
    BAD("bad");

    private final String name;

    ProcRequestStatus(String name) {
        this.name = name;
    }

}
