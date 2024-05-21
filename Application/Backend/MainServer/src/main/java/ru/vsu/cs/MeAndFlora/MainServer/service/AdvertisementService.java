package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;

import java.time.OffsetDateTime;

public interface AdvertisementService {

    LongDto addAdvertisement(String jwt);

    LongDto getCountOfAdvertisementInPeriod(String jwt, OffsetDateTime startTime, OffsetDateTime endTime);

}
