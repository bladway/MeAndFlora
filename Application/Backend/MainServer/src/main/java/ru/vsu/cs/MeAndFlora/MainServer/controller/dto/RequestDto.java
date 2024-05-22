package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;

@Data
@NoArgsConstructor
public class RequestDto {

    public RequestDto(String floraName, GeoJsonPointDto geoDto,
                      String status, boolean isBotanistVerified,
                      OffsetDateTime createdTime, OffsetDateTime postedTime) {
        this.floraName = floraName;
        this.geoDto = geoDto;
        this.status = status;
        this.isBotanistVerified = isBotanistVerified;
        this.createdTime = createdTime;
        this.postedTime = postedTime;
    }

    private String floraName;
    private GeoJsonPointDto geoDto;
    private String status;
    private boolean isBotanistVerified;
    private OffsetDateTime createdTime;
    private OffsetDateTime postedTime;
}
