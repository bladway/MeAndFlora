package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class FloraDto {

    public FloraDto(String name, String description, String type, boolean isSubscribed, String path) {
        this.name = name;
        this.description = description;
        this.type = type;
        this.isSubscribed = isSubscribed;
        this.path = path;
    }

    private String name;
    private String description;
    private String type;
    private boolean isSubscribed;
    private String path;
}
