package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;

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
@RequestMapping(path = "/auth")
class AuthorizationController {

    private final AuthorizationService authorizationService;

    @PostMapping("/register")
    public ResponseEntity<?> regiter(@RequestParam String login, @RequestParam String password, @RequestParam String ipAddress) {
        try {
            authorizationService.register(login, password, ipAddress);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (ApplicationException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    /*@PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String login, @RequestParam String password, @RequestParam String ipAddress) {
        return new ResponseEntity<>(authorizationService.login(login, password, ipAddress));
    }

    @PostMapping("/anonymus")
    public ResponseEntity<?> anonymusLogin(@RequestParam String ipAddress) {
        return new ResponseEntity<>(authorizationService.anonymusLogin(ipAddress));
    }

    @PostMapping("/exited")
    public ResponseEntity<?> userExit(@RequestParam String ipAddress) {
        return new ResponseEntity<>(authorizationService.userExit(ipAddress));
    }*/
    
}