package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.dto.ApplicationExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.dto.JwtResponseDto;
import ru.vsu.cs.MeAndFlora.MainServer.dto.NamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;
import ru.vsu.cs.MeAndFlora.MainServer.service.JwtService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequiredArgsConstructor
@RestController
@Tag(name = "Сontroller responsible for user authorization and working with sessions")
@RequestMapping(path = "/auth")
class AuthorizationController {

    public static final Logger authorizationControllerLogger = LoggerFactory.getLogger(AuthorizationController.class);

    private final AuthorizationService authorizationService;

    private final JwtService jwtService;

    @Operation(description = "User registration and automatic login. Returns jwt token + httpstatus - ok if successful"
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/register")
    public ResponseEntity<?> regiter(@RequestBody NamedAuthDto dto) {
        try {
            Long sessionId = authorizationService.register(dto.getLogin(), dto.getPassword(), dto.getIpAddress());
            String token = jwtService.generateToken(sessionId);
            JwtResponseDto responseDto = new JwtResponseDto(token);
            authorizationControllerLogger.info("Register with login: " + dto.getLogin() + " is successful");
            return new ResponseEntity<>(responseDto, HttpStatus.OK);
        } catch (ApplicationException e) {
            ApplicationExceptionDto exceptionDto = new ApplicationExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());
            authorizationControllerLogger.warn("Register with login: " + dto.getLogin() + " failed with message: " + e.getMessage());
            return new ResponseEntity<>(exceptionDto, HttpStatus.UNAUTHORIZED);
        }
    }

    @Operation(description = "User login. Returns sessionid + httpstatus - ok if successful" 
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String login, @RequestParam String password, @RequestParam String ipAddress) {
        try {
            Long sessionId = authorizationService.login(login, password, ipAddress);
            return new ResponseEntity<>(sessionId, HttpStatus.OK);
        } catch (ApplicationException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    @Operation(description = "Anonymus login. Returns sessionid + httpstatus - ok if successful" 
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/anonymus")
    public ResponseEntity<?> anonymusLogin(@RequestParam String ipAddress) {
        try {
            Long sessionId = authorizationService.anonymusLogin(ipAddress);
            return new ResponseEntity<>(sessionId, HttpStatus.OK);
        } catch (ApplicationException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    @Operation(description = "Notifying the server that the user has disconnected from the session."  
    + "Returns sessionid + httpstatus - ok if successful" 
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/exited")
    public ResponseEntity<?> userExit(@RequestParam Long sessionId) {
        try {
            Long thisSessionId = authorizationService.userExit(sessionId);
            return new ResponseEntity<>(thisSessionId, HttpStatus.OK);
        } catch (ApplicationException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }
    
}