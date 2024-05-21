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
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserResponse;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.AdvertisementViewRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

import java.io.IOException;
import java.net.MalformedURLException;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class RequestServiceImpl implements RequestService {

    @Value("${application.images.procpath}")
    private String procpath;

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final FloraRepository floraRepository;

    private final ProcRequestRepository procRequestRepository;

    private final USessionRepository uSessionRepository;

    private final AdvertisementViewRepository advertisementViewRepository;

    private final JwtUtil jwtUtil;

    private final JsonUtil jsonUtil;

    private final FileUtil fileUtil;

    private final KafkaProducer kafkaProducer;

    @Override
    public MultiValueMap<String, Object> procFloraRequest(String jwt, MultipartFile image, GeoJsonPointDto geoDto) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "admin has no rights to process flora request"
            );
        }

        int currentDayRequestsMaxCount = -1;
        int currentDayRequestsMade = 0;
        if (session.getUser() == null) {
            currentDayRequestsMaxCount =
                    advertisementViewRepository.findByCreatedTimeAfterAndSession(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(
                                           ZoneId
                                               .of("Europe/Moscow")
                                               .getRules()
                                               .getOffset(LocalDateTime.now())
                                    ),
                            session
                    ).size() + 5;
            currentDayRequestsMade =
                    procRequestRepository.findByCreatedTimeAfterAndSession(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(
                                            ZoneId
                                                    .of("Europe/Moscow")
                                                    .getRules()
                                                    .getOffset(LocalDateTime.now())
                                    ),
                            session
                    ).size();
        } else if (session.getUser().getRole().equals(UserRole.USER.getName())) {
            currentDayRequestsMaxCount =
                    advertisementViewRepository.findByCreatedTimeAfterAndSessionIn(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(
                                            ZoneId
                                                    .of("Europe/Moscow")
                                                    .getRules()
                                                    .getOffset(LocalDateTime.now())
                                    ),
                            session.getUser().getSessionList()
                    ).size() + 10;
            currentDayRequestsMade =
                    procRequestRepository.findByCreatedTimeAfterAndSessionIn(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(
                                            ZoneId
                                                    .of("Europe/Moscow")
                                                    .getRules()
                                                    .getOffset(LocalDateTime.now())
                                    ),
                            session.getUser().getSessionList()
                    ).size();
        }

        if ((currentDayRequestsMaxCount != -1) &&
                (currentDayRequestsMaxCount <= currentDayRequestsMade)) {
            throw new StateException(
                    errorPropertiesConfig.getLimitsexceeded(),
                    "too much requests made, watch the advertisement!"
            );
        }

        Point geoPos = geoDto == null ? null : jsonUtil.jsonToPoint(geoDto);

        ProcRequest procRequest = procRequestRepository.save(new ProcRequest(
                null,
                null,
                geoPos,
                ProcRequestStatus.NEURAL_PROC.getName(),
                session,
                null,
                false)
        );

        procRequest.setImagePath(procpath + procRequest.getRequestId() + ".jpg");

        try {
            kafkaProducer.sendProcRequestMessage(jwt, image, procRequest);
        } catch (IOException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotuploaded(),
                    "server can't process provided image"
            );
        }

        int waitIntervals = 50;
        while (!KafkaConsumer.procReturnFloraNames.containsKey(procRequest.getRequestId())) {
            if (waitIntervals == 0) {
                procRequestRepository.delete(procRequest);
                throw new ObjectException(
                        errorPropertiesConfig.getNeuraltimeout(),
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
                    errorPropertiesConfig.getFloranotfound(),
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
                    errorPropertiesConfig.getNeuraltouserbad(),
                    "invalid state transition from neural network to user"
            );
        }

        procRequest = procRequestRepository.save(procRequest);

        try {
            fileUtil.putImage(image, procRequest.getImagePath());
        } catch (IOException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotuploaded(),
                    "server can't process provided image"
            );
        }

        Resource resource;
        try {
            resource = fileUtil.getImage(procRequest.getFlora().getImagePath());
        } catch (MalformedURLException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotfound(),
                    "requested image not found"
            );
        }

        boolean isSubscribed = false;
        if (procRequest.getSession().getUser() != null) {
            for (Flora curFlora : procRequest.getSession().getUser().getTrackedPlants()) {
                if (procRequest.getFlora().getName().equals(curFlora.getName())) {
                    isSubscribed = true;
                    break;
                }
            }
        }

        MultiValueMap<String, Object> multiValueMap = new LinkedMultiValueMap<>();
        multiValueMap.add("requestId", procRequest.getRequestId());
        multiValueMap.add("floraDto", new FloraDto(
                procRequest.getFlora().getName(),
                procRequest.getFlora().getDescription(),
                procRequest.getFlora().getType(),
                isSubscribed
        ));
        multiValueMap.add("image", resource);

        return multiValueMap;
    }

    @Override
    public StringDto proceedRequest(String jwt, Long requestId, String answer) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
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
                    errorPropertiesConfig.getInvalidinput(),
                    "invalid request id provided"
            );
        }

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "admin has no rights to process flora request"
            );
        }

        if (!request.getStatus().equals(ProcRequestStatus.USER_PROC.getName())) {
            throw new StateException(
                    errorPropertiesConfig.getNeuraltouserbad(),
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
                    errorPropertiesConfig.getInvalidinput(),
                    "invalid user answer provided"
            );
        }

        request.setStatus(status);
        procRequestRepository.save(request);

        return new StringDto(status);

    }

    @Override
    public StringDto botanistDecisionProc(String jwt, Long requestId, String answer) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.BOTANIST.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only botanist can decide what to do with request"
            );
        }

        Optional<ProcRequest> ifrequest = procRequestRepository.findById(requestId);

        if (ifrequest.isEmpty()) {
            throw new InputException(
                    errorPropertiesConfig.getDoubleflora(),
                    "provided requestId not valid"
            );
        }

        ProcRequest request = ifrequest.get();

        if (!request.getStatus().equals(ProcRequestStatus.BOTANIST_PROC.getName())) {
            throw new StateException(
                    errorPropertiesConfig.getBotanisttoanotherbad(),
                    "invalid state transition from botanist proc to another"
            );
        }

        String status;
        Optional<Flora> ifflora = floraRepository.findByName(answer);

        if (answer.equals(ProcRequestStatus.BAD.getName())) {
            status = ProcRequestStatus.BAD.getName();
        } else if (ifflora.isPresent()) {
            if (request.getGeoPos() != null) {
                status = ProcRequestStatus.PUBLISHED.getName();
                request.setPostedTime(OffsetDateTime.now());
            } else {
                status = ProcRequestStatus.SAVED.getName();
            }
            request.setFlora(ifflora.get());
        } else {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "invalid flora name provided by botanist"
            );
        }

        request.setBotanistVerified(true);
        request.setStatus(status);
        procRequestRepository.save(request);

        return new StringDto(status);

    }

    @Override
    public LongDto deleteProcRequest(String jwt, Long requestId) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only admin can delete publications"
            );
        }

        Optional<ProcRequest> ifrequest = procRequestRepository.findById(requestId);

        if (ifrequest.isEmpty()) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "publication with provided requestId not found"
            );
        }

        ProcRequest request = ifrequest.get();

        if (!request.getStatus().equals(ProcRequestStatus.PUBLISHED.getName())) {
            throw new ObjectException(
                    errorPropertiesConfig.getInvalidinput(),
                    "request to delete is not a publication"
            );
        }

        procRequestRepository.delete(request);

        return new LongDto(request.getRequestId());

    }

}
