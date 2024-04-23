package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FileServiceImpl {
    
    @Value("${images.path}")
    private String path;

}
