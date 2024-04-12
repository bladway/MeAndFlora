package ru.vsu.cs.MeAndFlora.MainServer.service;

public interface AuthorizationService {
    void register(String login, String password, String ipAddress);
    void login(String login, String password, String ipAddress);
    void anonymusLogin(String ipAddress);
    void userExit(String ipAddress); 
}
