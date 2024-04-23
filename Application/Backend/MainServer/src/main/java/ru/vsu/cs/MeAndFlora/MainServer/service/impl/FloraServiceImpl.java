package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.util.Optional;

import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.AuthPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.RightsPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

@Service
@RequiredArgsConstructor
public class FloraServiceImpl implements FloraService {

    public static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    private final FloraRepository floraRepository;

    private final ProcRequestRepository procRequestRepository;

    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private final AuthPropertiesConfig authPropertiesConfig;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private final RightsPropertiesConfig rightsPropertiesConfig;

    @Override
    public Flora requestFlora(String token, String floraName) {
        Optional<USession> ifsession = uSessionRepository.findByJwtAndIsClosed(token, false);

        if (!ifsession.isPresent()) {
            throw new JwtException(
                jwtPropertiesConfig.getBadjwt(),
                "provided jwt not valid"
            );
        } else if (ifsession.get().isClosed()) {
            throw new AuthException(
                authPropertiesConfig.getSessionidproblem(), 
                "session has already closed"
            );
        }

        USession session = ifsession.get();

        if (session.getUser() != null && session.getUser().isAdmin()) {
            throw new RightsException(
                rightsPropertiesConfig.getNorights(),
                "admin has no rights to request flora"
            );
        }

        if (jwtUtil.ifTokenExpired(session.getCreatedTime())) {

            throw new JwtException(
                jwtPropertiesConfig.getExpired(),
                "jwt token lifetime has ended, get a new one"
            );
        }
    }

}
