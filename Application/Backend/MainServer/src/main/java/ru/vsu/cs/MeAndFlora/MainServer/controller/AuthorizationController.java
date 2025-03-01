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
import org.springframework.web.bind.annotation.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.service.UserService;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for user authorization and working with sessions and tokens")
@RequestMapping(path = "/auth")
class AuthorizationController {

    private static final Logger authorizationLogger =
            LoggerFactory.getLogger(AuthorizationController.class);

    private final UserService authorizationService;

    @Operation(description = "Post. User registration and automatic login. Requires: NamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/register",
            consumes = {MediaType.APPLICATION_JSON_VALUE}
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

            body = authorizationService.register(
                namedAuthDto.getLogin(), namedAuthDto.getPassword(), namedAuthDto.getIpAddress()
            );

            status = HttpStatus.OK;

            authorizationLogger.info(
                "Register with username: {} is successful", namedAuthDto.getLogin()
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
                 
            authorizationLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. User login. Requires: NamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/userLogin",
            consumes = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Object> login(
        @RequestBody @Schema(
                example = "{\"login\":\"testuser\", \"password\":\"testuser\", \"ipAddress\":\"1.1.1.1\"}"
        ) NamedAuthDto namedAuthDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = authorizationService.login(
                namedAuthDto.getLogin(), namedAuthDto.getPassword(), namedAuthDto.getIpAddress()
            );

            status = HttpStatus.OK;

            authorizationLogger.info(
                "Login with username: {} is successful", namedAuthDto.getLogin()
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

            authorizationLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Post. Anonymous login. Requires: UnnamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/anonymousLogin",
            consumes = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Object> anonymousLogin(
        @RequestBody @Schema(
                example = "{\"ipAddress\":\"1.1.1.1\"}"
        ) UnnamedAuthDto unnamedAuthDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = authorizationService.anonymousLogin(unnamedAuthDto.getIpAddress());

            status = HttpStatus.OK;

            authorizationLogger.info(
                "Anonymous login on ip: {} is successful", unnamedAuthDto.getIpAddress()
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

            authorizationLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Put. Get fresh jwt and refresh jwt (jwtr) (put new tokens). Requires: jwtr in header."
            + "Provides: DiJwtDto in body.")
    @PutMapping(
            value = "/refreshJwt"
    )
    public ResponseEntity<Object> refresh(
            @RequestHeader String jwtr
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = authorizationService.refresh(jwtr);

            status = HttpStatus.OK;

            authorizationLogger.info(
                "Refresh token: {} has worked successfully", jwtr
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

            authorizationLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        return new ResponseEntity<>(body, headers, status);

    }

    @Operation(description = "Patch. Change actual account data. Requires: jwt in header. AccountChangesDto in body"
            + "Provides: StringDto with actual username in body.")
    @PatchMapping(
            value = "/changeData"
    )
    public ResponseEntity<Object> change(
            @RequestHeader String jwt,
            @RequestBody AccountChangesDto accountChangesDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            StringDto returnDto = authorizationService.change(jwt,
                    accountChangesDto.getNewLogin(),
                    accountChangesDto.getNewPassword(),
                    accountChangesDto.getOldPassword()
            );

            body = returnDto;

            status = HttpStatus.OK;

            authorizationLogger.info(
                    "Account data for actual user: {} has saved successfully", returnDto.getString()
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

            authorizationLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }


}