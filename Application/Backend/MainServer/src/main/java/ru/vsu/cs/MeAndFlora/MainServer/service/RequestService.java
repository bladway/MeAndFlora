package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

import java.time.OffsetDateTime;

public interface RequestService {

    ReqAnswerDto procFloraRequest(String jwt, MultipartFile image, GeoJsonPointDto geoDto);

    StringDto proceedRequest(String jwt, Long requestId, String answer);

    StringDto botanistDecisionProc(String jwt, Long requestId, String answer);

    LongDto deleteProcRequest(String jwt, Long requestId);

    StatDtosDto getRequestsPerDayInPeriod(String jwt, OffsetDateTime startTime, OffsetDateTime endTime, int page, int size);

    LongsDto getAllPublications(String jwt, int page, int size);

    LongsDto getWatchedPublications(String jwt, int page, int size);

    LongsDto getBotanistProcessingRequests(String jwt, int page, int size);

    LongsDto getHistory(String jwt, int page, int size);

    RequestDto getProcessingRequest(String jwt, Long requestId);

}
