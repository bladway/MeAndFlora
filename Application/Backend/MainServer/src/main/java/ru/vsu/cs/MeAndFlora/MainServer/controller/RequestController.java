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
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with proc requests")
@RequestMapping(path = "/request")
public class RequestController {

    public static final Logger requestLogger =
            LoggerFactory.getLogger(RequestController.class);

    private final RequestService requestService;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    private final ObjectMapper objectMapper;

    @Operation(description = "Post. Post new processing request."
            + " Requires: jwt in header, GeoJsonPoint in body (optionally), multipart image in body."
            + " Provides: FloraDto in body, multipart image in body (jpg)")
    @PostMapping(
            value = "/request",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    private ResponseEntity<Object> procFloraRequest(
            @RequestHeader String jwt,
            @RequestPart(required = false) @Schema(
                    type = MediaType.APPLICATION_JSON_VALUE,
                    example = "{\"type\":\"Point\", \"coordinates\":[1.1, 1.2]}"
            ) byte[] geoDto,
            @RequestPart MultipartFile image
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            GeoJsonPointDto realGeoDto;

            try {
                realGeoDto = geoDto == null ? null : objectMapper.readValue(geoDto, GeoJsonPointDto.class);
            } catch (IOException e) {
                throw new InputException(objectPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            body = requestService.procFloraRequest(jwt, image, realGeoDto);

            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            status = HttpStatus.OK;

            requestLogger.info(
                    "Processing request {} defined flora as: {}",
                    ((MultiValueMap<String, Object>)body).getFirst("requestId"),
                    ((FloraDto)((MultiValueMap<String, Object>)body).getFirst("floraDto")).getName()
            );

        } catch (JwtException | RightsException | ObjectException | InputException | StateException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            headers.setContentType(MediaType.APPLICATION_JSON);

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : e.getClass() == StateException.class ?
                    HttpStatus.CONFLICT : HttpStatus.INTERNAL_SERVER_ERROR;

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Post for user answer on image (NOT USE FIRST). Requires: jwt in header,"
            + " UserOnNetworkAnswerDto in body."
            + " Provides: StringDto with proc request state.")
    @PostMapping(
            value = "/answered"
    )
    private ResponseEntity<Object> procFloraRequest(
            @RequestHeader String jwt,
            @RequestBody UserOnNetworkAnswerDto answerDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            StringDto dto = requestService.proceedRequest(
                    jwt,
                    answerDto.getRequestId(),
                    answerDto.getAnswer()
            );

            body = dto;

            status = HttpStatus.OK;

            requestLogger.info(
                    "Processing request {} move into state: {}",
                    answerDto.getRequestId(),
                    dto.getString()
            );

        } catch (JwtException | RightsException | ObjectException | InputException | StateException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            headers.setContentType(MediaType.APPLICATION_JSON);

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : e.getClass() == StateException.class ?
                    HttpStatus.CONFLICT : HttpStatus.INTERNAL_SERVER_ERROR;

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }



}
