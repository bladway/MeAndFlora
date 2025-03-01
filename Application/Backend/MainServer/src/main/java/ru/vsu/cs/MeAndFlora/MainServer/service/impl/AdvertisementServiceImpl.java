package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StatDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StatDtosDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.AdvertisementViewRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.AdvertisementView;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.AdvertisementService;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AdvertisementServiceImpl implements AdvertisementService {

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final USessionRepository uSessionRepository;

    private final AdvertisementViewRepository advertisementViewRepository;

    private final JwtUtil jwtUtil;

    @Override
    public LongDto addAdvertisement(String jwt) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() == null || session.getUser().getRole().equals(UserRole.USER.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only user or anonymous can see the advertisement"
            );
        }

        advertisementViewRepository.save(new AdvertisementView(session));

        return new LongDto(session.getSessionId());
    }

    @Override
    public StatDtosDto getAdvertisementPerDayInPeriod(String jwt, OffsetDateTime startTime, OffsetDateTime endTime, int page, int size) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    errorPropertiesConfig.getBadjwt(),
                    "provided jwt is not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getJwtCreatedTime())) {
            throw new JwtException(
                    errorPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only admin can request stats"
            );
        }

        Page<StatDto> statDtoPage = advertisementViewRepository.getAdvertisementPerDayInPeriod(
                startTime, endTime, PageRequest.of(page, size, Sort.by("day"))
        );
        List<StatDto> statDtoList = new ArrayList<>();
        statDtoPage.forEach(statDto -> statDtoList.add(statDto));
        return new StatDtosDto(statDtoList);
    }

}
