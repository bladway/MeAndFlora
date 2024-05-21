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

    @Operation(description = "Get. Get count of requests in given time duration (ONLY FOR ADMIN). "
            + " Requires: jwt in header, start and end offsetdatetime in query params"
            + " Provides: LongDto with count of requests.")
    @GetMapping(
            value = "/requests"
    )
    private ResponseEntity<Object> getRequestsCount(
            @RequestHeader String jwt,
            @RequestParam @Schema(example = "2024-05-21T15:59:58.623874+03:00") OffsetDateTime startTime,
            @RequestParam @Schema(example = "2024-05-21T16:00:32.435041+03:00") OffsetDateTime endTime
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            LongDto longDto = requestService.getCountOfRequestsInPeriod(
                    jwt,
                    startTime,
                    endTime
            );

            body = longDto;

            status = HttpStatus.OK;

            statisticsLogger.info(
                    "Get count of request in time successfully: {}",
                    longDto.getNumber()
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

    @Operation(description = "Get. Get count of advertisement seen in given time duration (ONLY FOR ADMIN). "
            + " Requires: jwt in header, start and end OffsetDateTime in query params"
            + " Provides: LongDto with count of advertisement.")
    @GetMapping(
            value = "/adverts"
    )
    private ResponseEntity<Object> getAdvertisementCount(
            @RequestHeader String jwt,
            @RequestParam @Schema(example = "2024-05-21T13:00:00+00:00") OffsetDateTime startTime,
            @RequestParam @Schema(example = "2024-05-21T14:00:00+00:00") OffsetDateTime endTime
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            LongDto longDto = advertisementService.getCountOfAdvertisementInPeriod(
                    jwt,
                    startTime,
                    endTime
            );

            body = longDto;

            status = HttpStatus.OK;

            statisticsLogger.info(
                    "Get count of request in time successfully: {}",
                    longDto.getNumber()
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