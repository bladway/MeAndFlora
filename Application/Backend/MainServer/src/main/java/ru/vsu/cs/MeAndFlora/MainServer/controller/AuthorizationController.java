package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@RestController
@RequestMapping(path = "/auth")
class AuthorizationController {

    @GetMapping("/")
    public String hello() {
        return "Hello, this is a server";
    }
    
}