package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringsDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;

public interface FloraService {

    Flora requestFlora(String jwt, String floraName);

    StringsDto getTypes(String jwt);

    StringsDto getFloraByType(String jwt, String typeName);

} 