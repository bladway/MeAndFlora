package ru.vsu.cs.MeAndFlora.MainServer.service;


public interface JwtService {
    public String generateToken(Long sessionId);
} 