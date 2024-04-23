package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.stereotype.Service;

import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;

public interface FloraService {

    Flora requestFlora(String token, String name);
    
} 