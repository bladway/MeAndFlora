package ru.vsu.cs.MeAndFlora.MainServer.service;

public interface AuthorizationService {
    Long register(String login, String password, String ipAddress);
    Long login(String login, String password, String ipAddress);
    Long anonymusLogin(String ipAddress);
    Long userExit(Long sessionId); 
}
