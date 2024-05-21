package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongsDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;

import java.time.OffsetDateTime;

public interface RequestService {

    MultiValueMap<String, Object> procFloraRequest(String jwt, MultipartFile image, GeoJsonPointDto geoDto);

    StringDto proceedRequest(String jwt, Long requestId, String answer);

    StringDto botanistDecisionProc(String jwt, Long requestId, String answer);

    LongDto deleteProcRequest(String jwt, Long requestId);

    LongDto getCountOfRequestsInPeriod(String jwt, OffsetDateTime startTime, OffsetDateTime endTime);

    LongsDto getAllPublications(String jwt, int page, int size);

    LongsDto getWatchedPublications(String jwt, int page, int size);

}
