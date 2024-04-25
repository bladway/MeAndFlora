package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.object.FloraProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
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

    @Operation(description = "Get. Get flora by name. Requires: jwt in header, name of plant in header."
    + "Provides: name of plant in header, description in header, type of plant in header,"
    + "Multipart image in body (jpg)")
    @GetMapping(value = "/byname")
    public ResponseEntity<?> getPlantByName(
        @RequestHeader String jwt, 
        @RequestParam String name
    ) {
        try {

            Flora flora = floraService.requestFlora(jwt, name);
            
            floraLogger.info(
                "Get plant with name: " + name + " is successful"
            );
            return ResponseEntity
                .status(HttpStatus.OK)
                .contentType(MediaType.valueOf("image/jpg"))
                .header("name", flora.getName())
                .header("description", flora.getDescription())
                .header("type", flora.getType())
                .body(fileService.getImage(flora.getImagePath()));

        } catch (JwtException e) {

            ExceptionDto exceptionDto = 
            new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());
    
            floraLogger.warn(
                "Invalid jwt: " + jwt + " message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(exceptionDto);

        } catch (RightsException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                "Rights problem to get flora with name: " + name + " failed with message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .body(exceptionDto);

        } catch (ObjectException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                "Problem with requested flora: " + name + " message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(exceptionDto);
                
        }
    }

    @Operation(description = "Post. Post new processing request. Requires: jwt in header, " 
    + "(optionally) GeoJsonPoint in header, multipart image in body."
    + "Provides: name of plant in header, description in header, type of plant in header,"
    + "Multipart image in body (jpg)")
    @PostMapping(value = "/request", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    private ResponseEntity<?> procFloraRequest(
        @RequestHeader String jwt, 
        @RequestHeader(required = false) Double x,
        @RequestHeader(required = false) Double y,
        @RequestBody MultipartFile image
    ) { 
        try {

            FloraProcRequest dto = floraService.procFloraRequest(jwt, x, y, image);
            fileService.putImage(image, dto.getProcRequest().getImagePath());
            
            floraLogger.info(
                "Processing request defined flora as: " + dto.getFlora().getName()
            );
            return ResponseEntity
                .status(HttpStatus.OK)
                .contentType(MediaType.valueOf("image/jpg"))
                .header("name", dto.getFlora().getName())
                .header("description", dto.getFlora().getDescription())
                .header("type", dto.getFlora().getType())
                .body(fileService.getImage(dto.getFlora().getImagePath()));

        } catch (JwtException e) {

            ExceptionDto exceptionDto = 
            new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());
    
            floraLogger.warn(
                "Invalid jwt: " + jwt + " message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(exceptionDto);

        } catch (RightsException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                "Rights problem to process flora, message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .body(exceptionDto);

        } catch (ObjectException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            floraLogger.warn(
                "Problem while processing flora image message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(exceptionDto);
                
        }

    }

}
