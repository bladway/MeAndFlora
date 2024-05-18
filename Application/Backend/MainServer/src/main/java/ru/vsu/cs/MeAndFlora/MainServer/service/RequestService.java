package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraProcRequestDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;

public interface RequestService {

    FloraProcRequestDto procFloraRequest(String jwt, byte[] image, GeoJsonPointDto geoDto);

}
