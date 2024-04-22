package ru.vsu.cs.MeAndFlora.MainServer.service;

public interface AuthorizationService {

    String register(String login, String password, String ipAddress);
    String login(String login, String password, String ipAddress);
    String anonymousLogin(String ipAddress);
    String userExit(String token); 

}
