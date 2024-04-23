package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.JwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.NamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UnnamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@RestController
@Tag(name = "Сontroller responsible for user authorization and working with sessions")
@RequestMapping(path = "/auth")
class AuthorizationController {

    public static final Logger authorizationControllerLogger = 
        LoggerFactory.getLogger(AuthorizationController.class);

    private final AuthorizationService authorizationService;

    @Operation(description = "User registration and automatic login. Returns jwt + " 
    + "httpstatus - ok if successful"
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody NamedAuthDto dto) {
        try {

            String token = authorizationService.register(dto.getLogin(), dto.getPassword(), dto.getIpAddress());
            JwtDto responseDto = new JwtDto(token);

            authorizationControllerLogger.info(
                "Register with username: " + dto.getLogin() + " is successful"
            );
            return new ResponseEntity<>(responseDto, HttpStatus.OK);

        } catch (ApplicationException e) {

            ExceptionDto exceptionDto = 
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationControllerLogger.warn(
                "Register with username: " + dto.getLogin() + " failed with message: " + e.getMessage()
            );
            return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);

        }
    }

    @Operation(description = "User login. Returns jwt + "
    + "httpstatus - ok if successful" 
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody NamedAuthDto dto) {
        try {

            String token = authorizationService.login(dto.getLogin(), dto.getPassword(), dto.getIpAddress());
            JwtDto responseDto = new JwtDto(token);

            authorizationControllerLogger.info(
                "Login with username: " + dto.getLogin() + " is successful"
            );
            return new ResponseEntity<>(responseDto, HttpStatus.OK);

        } catch (ApplicationException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationControllerLogger.warn(
                "Login with username: " + dto.getLogin() + " failed with message: " + e.getMessage()
            );
            return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);

        }
    }

    @Operation(description = "Anonymous login. Returns jwt + httpstatus - ok if successful" 
    + " and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/anonymous")
    public ResponseEntity<?> anonymousLogin(@RequestBody UnnamedAuthDto dto) {
        try {

            String token = authorizationService.anonymousLogin(dto.getIpAddress());
            JwtDto responseDto = new JwtDto(token);

            authorizationControllerLogger.info(
                "Anonymus login on ip: " + dto.getIpAddress() + " is successful"
            );
            return new ResponseEntity<>(responseDto, HttpStatus.OK);

        } catch (ApplicationException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationControllerLogger.warn(
                "Anonymous login on ip: " + dto.getIpAddress() + " failed with message: " + e.getMessage()
            );
            return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);

        }
    }

    @Operation(description = "Notifying the server that the user has disconnected from the session."  
    + " Returns jwt + httpstatus - ok if successful" 
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/exited")
    public ResponseEntity<?> userExit(@RequestBody JwtDto dto) {
        try {

            String token = authorizationService.userExit(dto.getToken());

            JwtDto responseDto = new JwtDto(token);

            authorizationControllerLogger.info(
                "User with token: " + dto.getToken() + " exited successful"
            );
            return new ResponseEntity<>(responseDto, HttpStatus.OK);

        } catch (ApplicationException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationControllerLogger.warn(
                "User with token: " + dto.getToken() + " not exited. Message: " + e.getMessage()
            );
            return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);

        }
    }
    
}