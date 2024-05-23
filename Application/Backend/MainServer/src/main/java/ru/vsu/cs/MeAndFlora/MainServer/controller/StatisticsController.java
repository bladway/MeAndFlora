package ru.vsu.cs.MeAndFlora.MainServer.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StatDtosDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.AdvertisementService;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

import java.time.OffsetDateTime;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with statistics")
@RequestMapping(path = "/stats")
public class StatisticsController {

    private static final Logger statisticsLogger =
            LoggerFactory.getLogger(PublicationController.class);

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final RequestService requestService;

    private final AdvertisementService advertisementService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Get. Get count of requests per dat in given time duration (ONLY FOR ADMIN). "
            + " Requires: jwt in header, start, end offsetdatetime, page and page size in query params"
            + " Provides: StatDtosDto with StatDto list.")
    @GetMapping(
            value = "/requests"
    )
    private ResponseEntity<Object> getRequestsCount(
            @RequestHeader String jwt,
            @RequestParam @Schema(example = "2024-05-12T15:59:58.623874+00:00") OffsetDateTime startTime,
            @RequestParam @Schema(example = "2024-05-24T02:00:32.435041+00:00") OffsetDateTime endTime,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            StatDtosDto statDtosDto = requestService.getRequestsPerDayInPeriod(
                    jwt,
                    startTime,
                    endTime,
                    page,
                    size
            );

            body = statDtosDto;

            status = HttpStatus.OK;

            statisticsLogger.info(
                    "Get count of request in time successfully, days: {}",
                    statDtosDto.getStatDtoList().size()
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            statisticsLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get count of advertisement per day seen in given time duration (ONLY FOR ADMIN). "
            + " Requires: jwt in header, start and end OffsetDateTime in query params"
            + " Provides: StatDtosDto with StatDtoList.")
    @GetMapping(
            value = "/adverts"
    )
    private ResponseEntity<Object> getAdvertisementCount(
            @RequestHeader String jwt,
            @RequestParam @Schema(example = "2024-05-21T13:00:00+00:00") OffsetDateTime startTime,
            @RequestParam @Schema(example = "2024-05-21T14:00:00+00:00") OffsetDateTime endTime,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            StatDtosDto statDtosDto = advertisementService.getAdvertisementPerDayInPeriod(
                    jwt,
                    startTime,
                    endTime,
                    page,
                    size
            );

            body = statDtosDto;

            status = HttpStatus.OK;

            statisticsLogger.info(
                    "Get count of request in time successfully: {}",
                    statDtosDto.getStatDtoList().size()
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            statisticsLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }


}