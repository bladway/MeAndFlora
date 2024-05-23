package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
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
    @JsonProperty("timestamp")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime createdTime;
    @JsonProperty("timestamp")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime postedTime;
}
