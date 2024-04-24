package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.NamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UnnamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@RestController
@Tag(name = "Сontroller responsible for user authorization and working with sessions")
@RequestMapping(path = "/auth")
class AuthorizationController {

    public static final Logger authorizationLogger = 
        LoggerFactory.getLogger(AuthorizationController.class);

    private final AuthorizationService authorizationService;

    @Operation(description = "Post. User registration and authomatic login. Requires: NamedAuthDto in body."
    + "Provides: DiJwtDto in body.")
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody NamedAuthDto dto) {
        try {

            DiJwtDto responseDto = authorizationService.register(dto.getLogin(), dto.getPassword(), dto.getIpAddress());

            authorizationLogger.info(
                "Register with username: " + dto.getLogin() + " is successful"
            );
            return ResponseEntity
                .status(HttpStatus.OK)
                .body(responseDto);

        } catch (AuthException e) {

            ExceptionDto exceptionDto = 
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "Register with username: " + dto.getLogin() + " failed with message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(exceptionDto);

        }
    }

    @Operation(description = "Post. User login. Requires: NamedAuthDto in body."
    + "Provides: DiJwtDto in body.")
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody NamedAuthDto dto) {
        try {

            DiJwtDto responseDto = authorizationService.login(dto.getLogin(), dto.getPassword(), dto.getIpAddress());

            authorizationLogger.info(
                "Login with username: " + dto.getLogin() + " is successful"
            );
            return ResponseEntity
                .status(HttpStatus.OK)
                .body(responseDto);

        } catch (AuthException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "Login with username: " + dto.getLogin() + " failed with message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(exceptionDto);

        }
    }

    @Operation(description = "Post. Anonymous login. Requires: UnnamedAuthDto in body."
    + "Provides: DiJwtDto in body.")
    @PostMapping("/anonymous")
    public ResponseEntity<?> anonymousLogin(@RequestBody UnnamedAuthDto dto) {
        try {

            DiJwtDto responseDto = authorizationService.anonymousLogin(dto.getIpAddress());

            authorizationLogger.info(
                "Anonymus login on ip: " + dto.getIpAddress() + " is successful"
            );
            return ResponseEntity
                .status(HttpStatus.OK)
                .body(responseDto);

        } catch (AuthException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "Anonymous login on ip: " + dto.getIpAddress() + " failed with message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(exceptionDto);

        }
    }

    @Operation(description = "Get. Get fresh jwt and refresh jwt (jwtr). Requires: jwtr in header."
    + "Provides: DiJwtDto in body.")
    @GetMapping("/refresh")
    public ResponseEntity<?> refresh(@RequestHeader String jwtr) {
        try {

            DiJwtDto responseDto = authorizationService.refresh(jwtr);

            authorizationLogger.info(
                "Refresh token: " + jwtr + " has worked successfully"
            );
            return ResponseEntity
                .status(HttpStatus.OK)
                .body(responseDto);

        } catch (JwtException e) {

            ExceptionDto exceptionDto = 
            new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());
    
            authorizationLogger.warn(
                "problem with refresh jwt: " + jwtr + " message: " + e.getMessage()
            );
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(exceptionDto);

        }
    }

    /*@Operation(description = "Notifying the server that the user has disconnected from the session."  
    + " Returns jwt + httpstatus - ok if successful" 
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/exited")
    public ResponseEntity<?> userExit(@RequestBody JwtDto dto) {
        try {

            String token = authorizationService.userExit(dto.getJwt());

            JwtDto responseDto = new JwtDto(token);

            authorizationLogger.info(
                "User with token: " + dto.getJwt() + " exited successful"
            );
            return new ResponseEntity<>(responseDto, HttpStatus.OK);

        } catch (AuthException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "User with token: " + dto.getToken() + " not exited. Message: " + e.getMessage()
            );
            return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);

        }
    }*/
    
}