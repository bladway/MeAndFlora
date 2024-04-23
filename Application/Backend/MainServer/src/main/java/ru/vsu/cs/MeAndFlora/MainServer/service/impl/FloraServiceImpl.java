package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

@Service
@RequiredArgsConstructor
public class FloraServiceImpl implements FloraService {

    public static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    private final FloraRepository floraRepository;

    private final ProcRequestRepository procRequestRepository;

    private final JwtUtil jwtUtil;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    @Override
    public Flora requestFlora(String token, String floraName) {
        if (jwtUtil.ifTokenExpired()) {
            
            throw new JwtException(
                jwtPropertiesConfig.getExpired(),
                "jwt token lifetime has ended, get a new one"
            );
        }
    }

}
