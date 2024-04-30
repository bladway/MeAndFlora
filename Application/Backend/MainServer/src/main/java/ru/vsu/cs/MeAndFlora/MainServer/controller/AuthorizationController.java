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
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.InputException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.NamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UnnamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for user authorization and working with sessions and tokens")
@RequestMapping(path = "/auth")
class AuthorizationController {

    public static final Logger authorizationLogger =
            LoggerFactory.getLogger(AuthorizationController.class);

    private final AuthorizationService authorizationService;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    @Operation(description = "Post. User registration and automatic login. Requires: NamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/register",
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Object> register(
        @RequestBody @Schema(
                example = "{\"login\":\"testuser\", \"password\":\"testuser\", \"ipAddress\":\"1.1.1.1\"}"
        ) NamedAuthDto namedAuthDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            DiJwtDto responseDto = authorizationService.register(
                namedAuthDto.getLogin(), namedAuthDto.getPassword(), namedAuthDto.getIpAddress()
            );

            authorizationLogger.info(
                    "Register with username: " + namedAuthDto.getLogin() + " is successful"
            );

            body = responseDto;

            status = HttpStatus.OK;

        } catch (AuthException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body = exceptionDto;

            status = e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. User login. Requires: NamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/login",
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Object> login(
        @RequestPart @Schema(
                example = "{\"login\":\"testuser\", \"password\":\"testuser\", \"ipAddress\":\"1.1.1.1\"}"
        ) NamedAuthDto namedAuthDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            DiJwtDto responseDto = authorizationService.login(
                namedAuthDto.getLogin(), namedAuthDto.getPassword(), namedAuthDto.getIpAddress()
            );

            authorizationLogger.info(
                    "Login with username: " + namedAuthDto.getLogin() + " is successful"
            );

            body = responseDto;

            status = HttpStatus.OK;

        } catch (AuthException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body = exceptionDto;

            status = e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Anonymous login. Requires: UnnamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/anonymous",
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Object> anonymousLogin(
        @RequestPart @Schema(
                example = "{\"ipAddress\":\"1.1.1.1\"}"
        ) UnnamedAuthDto unnamedAuthDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            DiJwtDto responseDto = authorizationService.anonymousLogin(unnamedAuthDto.getIpAddress());

            authorizationLogger.info(
                    "Anonymus login on ip: " + unnamedAuthDto.getIpAddress() + " is successful"
            );

            body = responseDto;

            status = HttpStatus.OK;

        } catch (AuthException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body = exceptionDto;

            status = e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Get. Get fresh jwt and refresh jwt (jwtr). Requires: jwtr in header."
            + "Provides: DiJwtDto in body.")
    @GetMapping(
            value = "/refresh",
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Object> refresh(
            @RequestHeader String jwtr
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            DiJwtDto responseDto = authorizationService.refresh(jwtr);

            authorizationLogger.info(
                    "Refresh token: " + jwtr + " has worked successfully"
            );

            body = responseDto;

            status = HttpStatus.OK;

        } catch (JwtException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body = exceptionDto;

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        return new ResponseEntity<>(body, headers, status);

    }

}