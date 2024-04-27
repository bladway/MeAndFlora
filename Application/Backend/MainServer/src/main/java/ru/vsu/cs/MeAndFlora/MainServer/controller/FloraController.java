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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.InputException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraProcRequestDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for working with flora")
@RequestMapping(path = "/flora")
public class FloraController {

    public static final Logger floraLogger =
            LoggerFactory.getLogger(FloraController.class);

    private final FloraService floraService;

    private final FileService fileService;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    @Operation(description = "Get. Get flora by name. Requires: jwt in header, name of plant in body."
            + "Provides: floraDto in body, multipart image in body (jpg)")
    @GetMapping(
            value = "/byname",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<MultiValueMap<String, Object>> getPlantByName(
            @RequestHeader String jwt,
            @RequestPart @Schema(type = MediaType.APPLICATION_JSON_VALUE) byte[] name
    ) {

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            ObjectMapper mapper = new ObjectMapper();

            String realName;

            try {
                realName = mapper.readValue(name, String.class);
            } catch (IOException e) {
                throw new InputException(objectPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            Flora flora = floraService.requestFlora(jwt, realName);

            floraLogger.info(
                    "Get plant with name: " + realName + " is successful"
            );

            body.add("floraDto", new FloraDto(
                    flora.getName(),
                    flora.getDescription(),
                    flora.getType()
            ));
            body.add("image", fileService.getImage(flora.getImagePath()));

            status = HttpStatus.OK;

        } catch (JwtException | RightsException | ObjectException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body.add("exceptionDto", exceptionDto);

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Post new processing request. Requires: jwt in header, "
            + "GeoJsonPoint in body (optionally), multipart image in body."
            + "Provides: FloraDto in body, multipart image in body (jpg)")
    @PostMapping(
            value = "/request",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    private ResponseEntity<MultiValueMap<String, Object>> procFloraRequest(
            @RequestHeader String jwt,
            @RequestPart(required = false) @Schema(type = MediaType.APPLICATION_JSON_VALUE) byte[] geoDto,
            @RequestPart MultipartFile image
    ) {

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            ObjectMapper mapper = new ObjectMapper();

            GeoJsonPointDto realGeoDto;

            try {
                realGeoDto = mapper.readValue(geoDto, GeoJsonPointDto.class);
            } catch (IOException e) {
                throw new InputException(objectPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            FloraProcRequestDto dto = floraService.procFloraRequest(jwt, realGeoDto, image);

            fileService.putImage(image, dto.getProcRequest().getImagePath());

            floraLogger.info(
                    "Processing request defined flora as: " + dto.getFlora().getName()
            );

            body.add("floraDto", new FloraDto(
                    dto.getFlora().getName(),
                    dto.getFlora().getDescription(),
                    dto.getFlora().getType()
            ));
            body.add("image", fileService.getImage(dto.getFlora().getImagePath()));

            status = HttpStatus.OK;

        } catch (JwtException | RightsException | ObjectException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body.add("exceptionDto", exceptionDto);

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == RightsException.class ?
                    HttpStatus.FORBIDDEN : e.getClass() == ObjectException.class ?
                    HttpStatus.NOT_FOUND : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

}
