package ru.vsu.cs.MeAndFlora.MainServer.config.object;

import lombok.Data;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

@Data
public class FloraProcRequest {
    
    public FloraProcRequest(Flora flora, ProcRequest procRequest) {
        this.flora = flora;
        this.procRequest = procRequest;
    }

    Flora flora;
    ProcRequest procRequest;

}
