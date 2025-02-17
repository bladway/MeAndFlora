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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with proc requests")
@RequestMapping(path = "/request")
public class RequestController {

    private static final Logger requestLogger =
            LoggerFactory.getLogger(RequestController.class);

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final RequestService requestService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Get. Get processing request information."
            + " Requires: jwt in header, requestId in query param."
            + " Provides: RequestDto in body, multipart image in body (jpg)")
    @GetMapping(
            value = "/byId"
    )
    private ResponseEntity<Object> getProcessingRequest(
            @RequestHeader String jwt,
            @RequestParam Long requestId
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            RequestDto requestDto = requestService.getProcessingRequest(jwt, requestId);

            body = requestDto;

            status = HttpStatus.OK;

            requestLogger.info(
                    "Processing request {} got with flora: {}",
                    requestId,
                    requestDto.getFloraName()
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

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get all request ids on which is needs to be botanist processed."
            + " Requires: jwt in header, page and size in query params (optionally)."
            + " Provides: longsDto with sorted request ids in body (first is much latest).")
    @GetMapping(
            value = "/allByBotanist"
    )
    public ResponseEntity<Object> getBotanistProcRequests(
            @RequestHeader String jwt,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body =  requestService.getBotanistProcessingRequests(jwt, page, size);

            status = HttpStatus.OK;

            requestLogger.info(
                    "Get requests to be processed with botanist, page: {}, with size: {} is successful",
                    page,
                    size
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

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Post new processing request."
            + " Requires: jwt in header, GeoJsonPoint in body (optionally), multipart image in body."
            + " Provides: ReqAnswerDto in body.")
    @PostMapping(
            value = "/create",
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
                throw new InputException(errorPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            if ((realGeoDto != null) && (realGeoDto.getCoordinates().size() < 2)) {
                realGeoDto = null;
            }

            ReqAnswerDto reqAnswerDto = requestService.procFloraRequest(jwt, image, realGeoDto);

            body = reqAnswerDto;

            status = HttpStatus.OK;

            requestLogger.info(
                    "Processing request {} defined flora as: {}",
                    reqAnswerDto.getRequestId(),
                    reqAnswerDto.getFloraDto().getName()
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

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Put. Post for user answer on image (NOT USE FIRST) (put request into another state). Requires: jwt in header,"
            + " AnswerDto in body with requestId and user answer."
            + " Provides: StringDto with proc request state.")
    @PutMapping(
            value = "/userDecision"
    )
    private ResponseEntity<Object> proceedRequest(
            @RequestHeader String jwt,
            @RequestBody AnswerDto answerDto
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

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Put. Post for botanist on proc request image. (put request into another state)"
            + " Requires: jwt in header,"
            + " AnswerDto in body with requestId and \"bad\" if photo bad and \"<floraname>\" if good."
            + " Provides: StringDto with proc request state.")
    @PutMapping(
            value = "/botanistDecision"
    )
    private ResponseEntity<Object> botanistProcDecision(
            @RequestHeader String jwt,
            @RequestBody AnswerDto answerDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            StringDto dto = requestService.botanistDecisionProc(
                    jwt,
                    answerDto.getRequestId(),
                    answerDto.getAnswer()
            );

            body = dto;

            status = HttpStatus.OK;

            requestLogger.info(
                    "Processing request {} moved into state: {}",
                    answerDto.getRequestId(),
                    dto.getString()
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

            requestLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }


}
