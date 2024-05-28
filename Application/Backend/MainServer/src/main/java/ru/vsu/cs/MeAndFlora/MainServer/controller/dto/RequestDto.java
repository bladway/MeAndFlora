package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;

@Data
@NoArgsConstructor
public class RequestDto {

    public RequestDto(String floraName, GeoJsonPointDto geoDto,
                      String status, boolean isBotanistVerified,
                      OffsetDateTime createdTime, OffsetDateTime postedTime,
                      String path) {
        this.floraName = floraName;
        this.geoDto = geoDto;
        this.status = status;
        this.isBotanistVerified = isBotanistVerified;
        this.createdTime = createdTime.withOffsetSameInstant(ZoneOffset.ofHours(3));
        this.postedTime = postedTime.withOffsetSameInstant(ZoneOffset.ofHours(3));
        this.path = path;
    }

    private String floraName;
    private GeoJsonPointDto geoDto;
    private String status;
    private boolean isBotanistVerified;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime createdTime;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime postedTime;
    private String path;
}
