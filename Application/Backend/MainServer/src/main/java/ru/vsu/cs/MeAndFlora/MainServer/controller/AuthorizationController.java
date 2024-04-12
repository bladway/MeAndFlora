package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.exception.ApplicationException;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequiredArgsConstructor
@RestController
@Tag(name = "Сontroller responsible for user authorization and working with sessions")
@RequestMapping(path = "/auth")
class AuthorizationController {

    private final AuthorizationService authorizationService;

    @Operation(description = "User registration and automatic login. Returns sessionid + httpstatus - ok if successful"
    + "and error message + httpstatus - unauthorized otherwise")
    @PostMapping("/register")
    public ResponseEntity<?> regiter(@RequestParam String login, @RequestParam String password, @RequestParam String ipAddress) {
        try {
            Long sessionId = authorizationService.register(login, password, ipAddress);
            return new ResponseEntity<>(sessionId, HttpStatus.OK);
        } catch (ApplicationException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
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