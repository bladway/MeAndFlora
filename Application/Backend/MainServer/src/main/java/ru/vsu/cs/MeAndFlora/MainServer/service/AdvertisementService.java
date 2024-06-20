package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StatDtosDto;

import java.time.OffsetDateTime;

public interface AdvertisementService {

    LongDto addAdvertisement(String jwt);

    StatDtosDto getAdvertisementPerDayInPeriod(String jwt, OffsetDateTime startTime, OffsetDateTime endTime, int page, int size);

}
