package ru.vsu.cs.MeAndFlora.MainServer.controller;

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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for working with flora")
@RequestMapping(path = "/flora")
public class FloraController {

    public static final Logger floraLogger =
            LoggerFactory.getLogger(FloraController.class);

    private final FloraService floraService;

    private final FileService fileService;

    @Operation(description = "Get. Get flora by name. Requires: jwt in header, name of plant in query param."
            + "Provides: floraDto in body, multipart image in body (jpg)")
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

            Flora flora = floraService.requestFlora(jwt, floraName);

            MultiValueMap<String, Object> bodyMap = new LinkedMultiValueMap<>();

            bodyMap.add("floraDto", new FloraDto(
                    flora.getName(),
                    flora.getDescription(),
                    flora.getType()
            ));
            bodyMap.add("image", fileService.getImage(flora.getImagePath(), null));

            body = bodyMap;

            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get plant with name: {} is successful", floraName
            );

        } catch (JwtException | RightsException | ObjectException | InputException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            headers.setContentType(MediaType.APPLICATION_JSON);

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get types of flora. Requires: jwt in header."
            + "Provides: StringsDto with list of flora type names in body")
    @GetMapping(
            value = "/types"
    )
    public ResponseEntity<Object> getFloraTypes(
            @RequestHeader String jwt
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.getTypes(jwt);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get types of flora is successful"
            );

        } catch (JwtException | RightsException | ObjectException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : HttpStatus.INTERNAL_SERVER_ERROR;

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get all flora names of some type. Requires: jwt in header, name of type in query param."
            + "Provides: StringsDto with list of flora names of the requested type in body")
    @GetMapping(
            value = "/bytype"
    )
    public ResponseEntity<Object> getFloraTypes(
        @RequestHeader String jwt,
        @RequestParam @Schema(
                example = "Дерево"
        ) String typeName
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = floraService.getFloraByType(jwt, typeName);

            status = HttpStatus.OK;

            floraLogger.info(
                    "Get flora of type: {} is successful", typeName
            );

        } catch (JwtException | RightsException | ObjectException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : HttpStatus.INTERNAL_SERVER_ERROR;

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

        } catch (JwtException | AuthException | RightsException | InputException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

            floraLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

}
