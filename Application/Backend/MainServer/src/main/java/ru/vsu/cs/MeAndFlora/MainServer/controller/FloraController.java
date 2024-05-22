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
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for working with flora")
@RequestMapping(path = "/flora")
public class FloraController {

    public static final Logger floraLogger =
            LoggerFactory.getLogger(FloraController.class);

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final FloraService floraService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Get. Get flora by name."
            + " Requires: jwt in header, name of plant in query param."
            + " Provides: floraDto in body, multipart image in body (jpg)")
    @GetMapping(
            value = "/byname"
    )
    public ResponseEntity<Object> getPlantByName(
        @RequestHeader String jwt,
        @RequestParam @Schema(
                example = "Одуванчик"
        ) String floraName
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.requestFlora(jwt, floraName);

            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get plant with name: {} is successful", floraName
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

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Create new flora by botanist."
            + " Requires: jwt in header, FloraDto in body, multipart image in body."
            + " Provides: StringDto with name of created flora")
    @PostMapping(
            value = "/new",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<Object> createNewFlora(
            @RequestHeader String jwt,
            @RequestPart @Schema(
                    type = MediaType.APPLICATION_JSON_VALUE,
                    example = "{\"name\":\"Фикус\", \"description\":\"Лучший друг\", \"type\":\"Цветок\"}"
            ) byte[] floraDto,
            @RequestPart MultipartFile image
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            FloraDto realFloraDto;

            try {
                realFloraDto = objectMapper.readValue(floraDto, FloraDto.class);
            } catch (IOException e) {
                throw new InputException(errorPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            body = floraService.createFlora(
                    jwt,
                    realFloraDto.getName(),
                    realFloraDto.getDescription(),
                    realFloraDto.getType(),
                    image
            );

            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Create plant with name: {} is successful", realFloraDto.getName()
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

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get types of flora."
            + " Requires: jwt in header, page and size in query params (optionally)."
            + " Provides: StringsDto with list of flora type names in body")
    @GetMapping(
            value = "/types"
    )
    public ResponseEntity<Object> getFloraTypes(
            @RequestHeader String jwt,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.getTypes(jwt, page, size);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get types of flora is successful"
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

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get all flora names of some type."
            + " Requires: jwt in header, page and size in query params (optionally)."
            + " Provides: StringsDto with list of flora names of the requested type in body")
    @GetMapping(
            value = "/bytype"
    )
    public ResponseEntity<Object> getFloraTypes(
        @RequestHeader String jwt,
        @RequestParam @Schema(
                example = "Дерево"
        ) String typeName,
        @RequestParam(required = false, defaultValue = "0") int page,
        @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.getFloraByType(jwt, typeName, page, size);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get flora of type: {} is successful", typeName
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

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Subscribe/unsubscribe to/from plant."
            + " Requires: jwt in header, name of plant in query param."
            + " Provides: StringDto with plant name in body.")
    @PostMapping(
            value = "/subscribe"
    )
    public ResponseEntity<Object> unsubOrSub(
            @RequestHeader String jwt,
            @RequestParam @Schema(
                    example = "Одуванчик"
            ) String floraName
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.unsubOrSub(jwt, floraName);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Change of subscription on: {} has passed successfully", floraName
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

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

}
