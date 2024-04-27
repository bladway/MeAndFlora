package ru.vsu.cs.MeAndFlora.MainServer.controller;


import java.io.IOException;
import java.time.OffsetDateTime;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.annotation.MultipartConfig;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraProcRequestDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
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

    /*private ResponseEntity<?> invalidJwtResponse(JwtException e, String token) {
        ExceptionDto exceptionDto = 
        new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

        floraLogger.warn(
            "Invalid jwt: " + token + " message: " + e.getMessage()
        );
        return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);
    }*/

    @Operation(description = "Get. Get flora by name. Requires: jwt in header, name of plant in body."
            + "Provides: floraDto in body, multipart image in body (jpg)")
    @GetMapping(
            value = "/byname",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<?> getPlantByName(
            @RequestHeader String jwt,
            @RequestBody String name
    ) {
        try {

            Flora flora = floraService.requestFlora(jwt, name);

            floraLogger.info(
                    "Get plant with name: " + name + " is successful"
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("floraDto", new FloraDto(
                    flora.getName(),
                    flora.getDescription(),
                    flora.getType()
            ));
            body.add("image", fileService.getImage(flora.getImagePath()));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.OK);

        } catch (JwtException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                    "Invalid jwt: " + jwt + " message: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.UNAUTHORIZED);

        } catch (RightsException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                    "Rights problem to get flora with name: " + name + " failed with message: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.FORBIDDEN);

        } catch (ObjectException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                    "Problem with requested flora: " + name + " message: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.NOT_FOUND);

        }
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
            @RequestPart(required = true) @Schema(type = MediaType.APPLICATION_JSON_VALUE) byte[] geoDto,
            @RequestPart(required = false) MultipartFile image
    ) {
        try {

            ObjectMapper mapper = new ObjectMapper();

            GeoJsonPointDto realGeoDto = mapper.readValue(geoDto, GeoJsonPointDto.class);

            FloraProcRequestDto dto = floraService.procFloraRequest(jwt, realGeoDto, image);

            fileService.putImage(image, dto.getProcRequest().getImagePath());

            floraLogger.info(
                    "Processing request defined flora as: " + dto.getFlora().getName()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("floraDto", new FloraDto(
                    dto.getFlora().getName(),
                    dto.getFlora().getDescription(),
                    dto.getFlora().getType()
            ));
            body.add("image", fileService.getImage(dto.getFlora().getImagePath()));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.OK);

        } catch (JwtException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                    "Invalid jwt: " + jwt + " message: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.UNAUTHORIZED);

        } catch (RightsException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                    "Rights problem to process flora, message: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.FORBIDDEN);

        } catch (ObjectException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                    "Problem while processing flora image message: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.NOT_FOUND);

        } catch (IOException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto("jsoninvalid", e.getMessage(), OffsetDateTime.now());

            floraLogger.warn(
                    "Problem while processing json to file GeoJsonPointDto: " + e.getMessage()
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.add("jwt", jwt);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.BAD_REQUEST);

        }

    }

}
