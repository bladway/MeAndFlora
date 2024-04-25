package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.web.multipart.MultipartFile;

import ru.vsu.cs.MeAndFlora.MainServer.config.object.FloraProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;

public interface FloraService {

    Flora requestFlora(String jwt, String floraName);
    FloraProcRequest procFloraRequest(String jwt, GeoJsonPointDto geoDto, MultipartFile image);

} 