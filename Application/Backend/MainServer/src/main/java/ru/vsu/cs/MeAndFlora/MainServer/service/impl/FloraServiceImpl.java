package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JsonUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.KafkaConsumer;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.KafkaProducer;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.RightsPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraProcRequestDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

import java.time.Duration;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FloraServiceImpl implements FloraService {

    public static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    @Value("${images.procpath}")
    private String procpath;

    private final FloraRepository floraRepository;

    private final ProcRequestRepository procRequestRepository;

    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private final JsonUtil jsonUtil;

    private final KafkaProducer kafkaProducer;

    private final KafkaConsumer kafkaConsumer;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private final RightsPropertiesConfig rightsPropertiesConfig;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    private USession procJwt(String jwt) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }
        return session;
    }

    @Override
    public Flora requestFlora(String jwt, String floraName) {
        USession session = procJwt(jwt);

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to request flora"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "requested flora not found"
            );
        }

        return ifflora.get();

    }

    @Override
    public FloraProcRequestDto procFloraRequest(String jwt, byte[] image, GeoJsonPointDto geoDto) {
        USession session = procJwt(jwt);

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to process flora request"
            );
        }

        Point geoPos = geoDto == null ? null : jsonUtil.jsonToPoint(geoDto);

        ProcRequest procRequest = procRequestRepository.save(new ProcRequest(
                "", null, geoPos, ProcRequestStatus.NEURAL_PROC.getName(), session, null));

        procRequest.setImagePath(procpath + procRequest.getRequestId() + ".jpg");

        // this logic needs to be separated for async work
        //String floraName = "oduvanchik";
        kafkaProducer.sendProcRequestMessage(jwt, image, procRequest);

        while (!KafkaConsumer.procReturnFloraNames.containsKey(procRequest.getRequestId())) {
            try {
                wait(1500);
            } catch (InterruptedException e) {
                break;
            }
        }

        String floraName = KafkaConsumer.procReturnFloraNames.get(procRequest.getRequestId());

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "neural network give unexpected result, internal backend error"
            );
        }

        Flora flora = ifflora.get();

        procRequest.setFlora(flora);
        procRequest.setStatus(ProcRequestStatus.USER_PROC.getName());

        procRequestRepository.save(procRequest);

        return new FloraProcRequestDto(flora, procRequest);

    }

}
