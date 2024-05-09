package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraProcRequestDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;

public interface FloraService {

    Flora requestFlora(String jwt, String floraName);

    FloraProcRequestDto procFloraRequest(String jwt, byte[] image, GeoJsonPointDto geoDto);

} 