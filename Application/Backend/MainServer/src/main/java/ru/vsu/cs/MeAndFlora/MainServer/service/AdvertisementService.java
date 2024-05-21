package ru.vsu.cs.MeAndFlora.MainServer.service;

import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;

public interface AdvertisementService {

    LongDto addAdvertisement(String jwt);

}
