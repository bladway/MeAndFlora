package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringsDto;

public interface FloraService {

    MultiValueMap<String, Object> requestFlora(String jwt, String floraName);

    StringDto createFlora(String jwt, String floraName, String description, String type, MultipartFile image);

    StringsDto getTypes(String jwt, int page, int size);

    StringsDto getFloraByType(String jwt, String typeName, int page, int size);

    StringDto unsubOrSub(String jwt, String floraName);

} 