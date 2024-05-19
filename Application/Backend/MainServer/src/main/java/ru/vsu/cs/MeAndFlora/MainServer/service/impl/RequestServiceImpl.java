package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.RightsPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.StatePropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserResponse;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

import java.io.IOException;
import java.net.MalformedURLException;
import java.time.OffsetDateTime;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class RequestServiceImpl implements RequestService {

    @Value("${images.procpath}")
    private String procpath;

    private final FloraRepository floraRepository;

    private final ProcRequestRepository procRequestRepository;

    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private final JsonUtil jsonUtil;

    private final FileUtil fileUtil;

    private final KafkaProducer kafkaProducer;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private final RightsPropertiesConfig rightsPropertiesConfig;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    private final StatePropertiesConfig statePropertiesConfig;

    @Override
    public MultiValueMap<String, Object> procFloraRequest(String jwt, MultipartFile image, GeoJsonPointDto geoDto) {
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

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to process flora request"
            );
        }

        Point geoPos = geoDto == null ? null : jsonUtil.jsonToPoint(geoDto);

        ProcRequest procRequest = procRequestRepository.save(new ProcRequest(
                null, null, geoPos, ProcRequestStatus.NEURAL_PROC.getName(), session, null));

        procRequest.setImagePath(procpath + procRequest.getRequestId() + ".jpg");

        try {
            kafkaProducer.sendProcRequestMessage(jwt, image, procRequest);
        } catch (IOException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    objectPropertiesConfig.getImagenotuploaded(),
                    "server can't process provided image"
            );
        }

        int waitIntervals = 100;
        while (!KafkaConsumer.procReturnFloraNames.containsKey(procRequest.getRequestId())) {
            if (waitIntervals == 0) {
                procRequestRepository.delete(procRequest);
                throw new ObjectException(
                        objectPropertiesConfig.getNeuraltimeout(),
                        "neural network result hasn't got in expected period"
                );
            }

            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                continue;
            }

            waitIntervals--;
        }

        String floraName = KafkaConsumer.procReturnFloraNames.remove(procRequest.getRequestId());

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "neural network give unexpected result, internal backend error"
            );
        }

        Flora flora = ifflora.get();

        procRequest.setFlora(flora);
        if (procRequest.getStatus().equals(ProcRequestStatus.NEURAL_PROC.getName())) {
            procRequest.setStatus(ProcRequestStatus.USER_PROC.getName());
        } else {
            procRequestRepository.delete(procRequest);
            throw new StateException(
                    statePropertiesConfig.getNeuraltouserbad(),
                    "invalid state transition from neural network to user"
            );
        }

        procRequest = procRequestRepository.save(procRequest);

        try {
            fileUtil.putImage(image, procRequest.getImagePath());
        } catch (IOException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    objectPropertiesConfig.getImagenotuploaded(),
                    "server can't process provided image"
            );
        }

        Resource resource;
        try {
            resource = fileUtil.getImage(procRequest.getFlora().getImagePath());
        } catch (MalformedURLException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    objectPropertiesConfig.getImagenotfound(),
                    "requested image not found"
            );
        }

        MultiValueMap<String, Object> multiValueMap = new LinkedMultiValueMap<>();
        multiValueMap.add("requestId", procRequest.getRequestId());
        multiValueMap.add("floraDto", new FloraDto(
                procRequest.getFlora().getName(),
                procRequest.getFlora().getDescription(),
                procRequest.getFlora().getType()
        ));
        multiValueMap.add("image", resource);

        return multiValueMap;
    }

    @Override
    public StringDto proceedRequest(String jwt, Long requestId, String answer) {
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

        ProcRequest request = null;

        boolean exists = false;
        for (ProcRequest curRequest : session.getProcRequestList()) {
            if (curRequest.getRequestId().equals(requestId)) {
                exists = true;
                request = curRequest;
                break;
            }
        }
        if (!exists) {
            throw new InputException(
                    objectPropertiesConfig.getInvalidinput(),
                    "invalid request id provided"
            );
        }

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to process flora request"
            );
        }

        if (!request.getStatus().equals(ProcRequestStatus.USER_PROC.getName())) {
            throw new StateException(
                    statePropertiesConfig.getNeuraltouserbad(),
                    "invalid state transition from user to another"
            );
        }

        String status;

        if (answer.equals(UserResponse.YES.getName())) {
            if (request.getGeoPos() != null) {
                status = ProcRequestStatus.PUBLISHED.getName();
                request.setPostedTime(OffsetDateTime.now());
            } else {
                status = ProcRequestStatus.SAVED.getName();
            }
        } else if (answer.equals(UserResponse.NO.getName())) {
            status = ProcRequestStatus.BOTANIST_PROC.getName();
            request.setFlora(null);
        } else if (answer.equals(UserResponse.UNKNOWN.getName())) {
            status = ProcRequestStatus.SAVED.getName();
        } else {
            throw new InputException(
                    objectPropertiesConfig.getInvalidinput(),
                    "invalid user answer provided"
            );
        }

        request.setStatus(status);
        procRequestRepository.save(request);

        return new StringDto(status);

    }

}
