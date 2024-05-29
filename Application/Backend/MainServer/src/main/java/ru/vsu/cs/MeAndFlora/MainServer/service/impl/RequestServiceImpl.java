package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserResponse;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.repository.AdvertisementViewRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
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

    private final ImageUtil fileUtil;

    private final KafkaProducer kafkaProducer;

    @Override
    public ReqAnswerDto procFloraRequest(String jwt, MultipartFile image, GeoJsonPointDto geoDto) {
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
                                    .atOffset(ZoneOffset.ofHours(3)),
                            session
                    ).size() + 5;
            currentDayRequestsMade =
                    procRequestRepository.findByCreatedTimeAfterAndSession(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(ZoneOffset.ofHours(3)),
                            session
                    ).size();
        } else if (session.getUser().getRole().equals(UserRole.USER.getName())) {
            currentDayRequestsMaxCount =
                    advertisementViewRepository.findByCreatedTimeAfterAndSessionIn(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(ZoneOffset.ofHours(3)),
                            session.getUser().getSessionList()
                    ).size() + 10;
            currentDayRequestsMade =
                    procRequestRepository.findByCreatedTimeAfterAndSessionIn(
                            OffsetDateTime
                                    .now()
                                    .toLocalDate()
                                    .atStartOfDay()
                                    .atOffset(ZoneOffset.ofHours(3)),
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

        if (ManagementFactory.getThreadMXBean().getThreadCount() > 50) {
            throw new ObjectException(
                    errorPropertiesConfig.getOverloaded(),
                    "sorry server is overloaded, try again later."
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

        /*Resource resource;
        try {
            resource = fileUtil.getImage(procRequest.getFlora().getImagePath());
        } catch (MalformedURLException e) {
            procRequestRepository.delete(procRequest);
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotfound(),
                    "requested image not found"
            );
        } */

        boolean isSubscribed = false;
        if (procRequest.getSession().getUser() != null) {
            for (Flora curFlora : procRequest.getSession().getUser().getTrackedPlants()) {
                if (procRequest.getFlora().getName().equals(curFlora.getName())) {
                    isSubscribed = true;
                    break;
                }
            }
        }

        return new ReqAnswerDto(procRequest.getRequestId(),
                new FloraDto(
                procRequest.getFlora().getName(),
                procRequest.getFlora().getDescription(),
                procRequest.getFlora().getType(),
                isSubscribed,
                procRequest.getFlora().getImagePath()
        ));
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

        Optional<ProcRequest> ifrequest;
        if (session.getUser() != null) {
            List<USession> sessionList = session.getUser().getSessionList();
            ifrequest = procRequestRepository.findBySessionInAndRequestId(sessionList, requestId);
        } else {
            ifrequest = procRequestRepository.findBySessionAndRequestId(session, requestId);
        }
        if (ifrequest.isEmpty()) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "invalid request id provided"
            );
        }

        ProcRequest request = ifrequest.get();

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

    @Override
    public StatDtosDto getRequestsPerDayInPeriod(String jwt, OffsetDateTime startTime, OffsetDateTime endTime, int page, int size) {
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
                    "only admin can request stats"
            );
        }

        Page<StatDto> statDtoPage = procRequestRepository.getRequestsPerDayInPeriod(
                startTime, endTime, PageRequest.of(page, size, Sort.by("day"))
        );
        List<StatDto> statDtoList = new ArrayList<>();
        statDtoPage.forEach(statDto -> statDtoList.add(statDto));
        return new StatDtosDto(statDtoList);
    }

    @Override
    public LongsDto getAllPublications(String jwt, int page, int size) {
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
                    "only admin can get a list of all publications"
            );
        }

        Page<ProcRequest> procRequestPage = procRequestRepository.findByStatus(
                ProcRequestStatus.PUBLISHED.getName(),
                PageRequest.of(page, size, Sort.by("postedTime").descending())
        );
        List<Long> requestIds = new ArrayList<>();
        procRequestPage.forEach(procRequest -> requestIds.add(procRequest.getRequestId()));
        return new LongsDto(requestIds);
    }

    public LongsDto getWatchedPublications(String jwt, int page, int size) {
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

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.USER.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only user can get a list of all watched publications"
            );
        }

        MafUser user = session.getUser();
        List<Flora> tracked = user.getTrackedPlants();

        Page<ProcRequest> procRequestPage = procRequestRepository.findByFloraInAndStatus(
                tracked,
                ProcRequestStatus.PUBLISHED.getName(),
                PageRequest.of(page, size, Sort.by("postedTime").descending())
        );
        List<Long> requestIds = new ArrayList<>();
        procRequestPage.forEach(procRequest -> requestIds.add(procRequest.getRequestId()));
        return new LongsDto(requestIds);
    }

    @Override
    public LongsDto getBotanistProcessingRequests(String jwt, int page, int size) {
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

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.BOTANIST.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only botanist can get a list of all requests needed to evaluate"
            );
        }

        Page<ProcRequest> procRequestPage = procRequestRepository.findByStatus(
                ProcRequestStatus.BOTANIST_PROC.getName(),
                PageRequest.of(page, size, Sort.by("createdTime").descending())
        );
        List<Long> requestIds = new ArrayList<>();
        procRequestPage.forEach(procRequest -> requestIds.add(procRequest.getRequestId()));
        return new LongsDto(requestIds);
    }

    @Override
    public LongsDto getHistory(String jwt, int page, int size) {
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

        if (!(session.getUser() != null && (session.getUser().getRole().equals(UserRole.BOTANIST.getName())
        || session.getUser().getRole().equals(UserRole.USER.getName())))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only botanist or user can get a history ids"
            );
        }

        MafUser user = session.getUser();

        List<String> statusList = new ArrayList<>();
        statusList.add(ProcRequestStatus.BOTANIST_PROC.getName());
        statusList.add(ProcRequestStatus.SAVED.getName());
        statusList.add(ProcRequestStatus.PUBLISHED.getName());
        statusList.add(ProcRequestStatus.BAD.getName());

        Page<ProcRequest> procRequestPage = procRequestRepository.findBySessionInAndStatusIn(
                user.getSessionList(),
                statusList,
                PageRequest.of(page, size, Sort.by("createdTime").descending())
        );
        List<Long> requestIds = new ArrayList<>();
        procRequestPage.forEach(procRequest -> requestIds.add(procRequest.getRequestId()));
        return new LongsDto(requestIds);
    }

    @Override
    public RequestDto getProcessingRequest(String jwt, Long requestId) {
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

        if (session.getUser() == null) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "anonymous can't directly get requests"
            );
        }

        MafUser user = session.getUser();

        Optional<ProcRequest> ifrequest = procRequestRepository.findById(requestId);

        if (ifrequest.isEmpty()) {
            throw new ObjectException(
                    errorPropertiesConfig.getRequestnotfound(),
                    "requested request :) not found"
            );
        }

        ProcRequest request = ifrequest.get();

        if (request.getStatus().equals(ProcRequestStatus.NEURAL_PROC.getName())
                || request.getStatus().equals(ProcRequestStatus.USER_PROC.getName())) {
            throw new ObjectException(
                    errorPropertiesConfig.getBadrequeststate(),
                    "requested request :) not allowed to get"
            );
        }

        if (request.getStatus().equals(ProcRequestStatus.BOTANIST_PROC.getName())
                &&
                (!user.getRole().equals(UserRole.BOTANIST.getName())
                && (!user.getRole().equals(UserRole.USER.getName())))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only botanist or user can get this request"
            );
        }

        if (!request.getStatus().equals(ProcRequestStatus.PUBLISHED.getName())
                && user.getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "admin can get only publication requests"
            );
        }

        return new RequestDto(
                request.getFlora() != null ? request.getFlora().getName() : "",
                request.getGeoPos() != null ? jsonUtil.pointToJson(request.getGeoPos()) : null,
                request.getStatus(),
                request.isBotanistVerified(),
                request.getCreatedTime(),
                request.getPostedTime(),
                request.getImagePath()
        );

    }

}
