package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class LongsDto {

    public LongsDto(List<Long> longs) {
        this.longs = longs;
    }

    private List<Long> longs;

}
