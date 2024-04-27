package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class GeoJsonPointDto {

    public GeoJsonPointDto(String type, List<Double> coordinates) {
        this.type = type;
        this.coordinates = coordinates;
    }

    private String type;
    private List<Double> coordinates;

}
