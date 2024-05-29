package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

@Data
@NoArgsConstructor
public class StatDto {

    public StatDto(OffsetDateTime date, Long count) {
        this.date = date.withOffsetSameInstant(ZoneOffset.ofHours(3));
        this.count = count;
    }

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX")
    private OffsetDateTime date;
    private Long count;


}