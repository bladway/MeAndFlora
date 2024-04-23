package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GetFloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for anonymous use cases")
@RequestMapping(path = "/anonymous")
public class AnonymousController {
    
    public static final Logger authorizationControllerLogger = 
        LoggerFactory.getLogger(AnonymousController.class);

    private final FloraService plantService;

    private final FileService fileService;

    private ResponseEntity<?> invalidJwtResponse(JwtException e, String token) {
        ExceptionDto exceptionDto = 
        new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

        authorizationControllerLogger.warn(
            "Invalid jwt: " + token + " message: " + e.getMessage()
        );
        return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);
    }

    @GetMapping("/plants/byname")
    public ResponseEntity<?> getPlantByName(@RequestBody GetFloraDto dto) {
        try {

            Flora flora = plantService.requestFlora(dto.getToken(), dto.getName());
            FloraDto responseDto = new FloraDto();

            authorizationControllerLogger.info(
                "Get plant with name: " + dto.getName() + " is successful"
            );
            return new ResponseEntity<>(responseDto, HttpStatus.OK);

        } catch (JwtException e) {

            return invalidJwtResponse(e, dto.getToken());

        } catch (ApplicationException e) {

            ExceptionDto exceptionDto = 
            new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationControllerLogger.warn(
                "Request to find plant with name: " + dto.getName() + " failed with message: " + e.getMessage()
            );
            return new ResponseEntity<>(exceptionDto, HttpStatus.NOT_FOUND);

        }
    }

}
