package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

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
