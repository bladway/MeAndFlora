package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

@Data
@NoArgsConstructor
public class FloraProcRequestDto {

    public FloraProcRequestDto(Flora flora, ProcRequest procRequest) {
        this.flora = flora;
        this.procRequest = procRequest;
    }

    Flora flora;
    ProcRequest procRequest;

}
