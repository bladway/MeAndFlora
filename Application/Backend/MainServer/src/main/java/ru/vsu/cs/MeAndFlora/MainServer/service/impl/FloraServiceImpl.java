package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.FileUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.RightsPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.UserRole;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.FloraDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StringsDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.FloraService;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FloraServiceImpl implements FloraService {

    @Value("${images.getpath}")
    private String getpath;

    private final FloraRepository floraRepository;

    private final USessionRepository uSessionRepository;

    private final JwtUtil jwtUtil;

    private final FileUtil fileUtil;

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private final RightsPropertiesConfig rightsPropertiesConfig;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    private final MafUserRepository mafUserRepository;

    @Override
    public MultiValueMap<String, Object> requestFlora(String jwt, String floraName) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to request flora"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "requested flora not found"
            );
        }

        Flora flora = ifflora.get();

        Resource resource;
        try {
            resource = fileUtil.getImage(flora.getImagePath());
        } catch (MalformedURLException e) {
            throw new ObjectException(
                    objectPropertiesConfig.getImagenotfound(),
                    "requested image not found"
            );
        }

        MultiValueMap<String, Object> multiValueMap = new LinkedMultiValueMap<>();
        multiValueMap.add("floraDto", new FloraDto(
                flora.getName(),
                flora.getDescription(),
                flora.getType()
        ));
        multiValueMap.add("image", resource);

        return multiValueMap;

    }

    @Override
    public StringDto createFlora(String jwt, String floraName, String description, String type, MultipartFile image) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.BOTANIST.getName()))) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "only botanist can create flora"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isPresent()) {
            throw new ObjectException(
                    objectPropertiesConfig.getDoubleflora(),
                    "requested to create flora already exists"
            );
        }

        try {
            fileUtil.putImage(image, getpath + floraName + ".jpg");
        } catch (IOException e) {
            throw new ObjectException(
                objectPropertiesConfig.getImagenotuploaded(),
                "server can't upload provided image"
            );
        }

        Flora flora = floraRepository.save(new Flora(getpath + floraName + ".jpg", floraName, description, type));

        return new StringDto(flora.getName());
    }

    @Override
    public StringsDto getTypes(String jwt) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to get types of flora"
            );
        }

        List<String> types = floraRepository.getTypesOfFlora();

        if (types.isEmpty()) {
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "there are no typed flora"
            );
        }

        return new StringsDto(types);
    }

    @Override
    public StringsDto getFloraByType(String jwt, String typeName) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "admin has no rights to get flora names by type"
            );
        }

        List<Flora> floras = floraRepository.findByType(typeName);
        List<String> floraNames = new ArrayList<>();
        floras.forEach(flora -> floraNames.add(flora.getName()));

        if (floraNames.isEmpty()) {
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "there are no flora of requested type"
            );
        }

        return new StringsDto(floraNames);
    }

    @Override
    public StringDto unsubOrSub(String jwt, String floraName) {
        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

        if (ifsession.isEmpty()) {
            throw new JwtException(
                    jwtPropertiesConfig.getBadjwt(),
                    "provided jwt not valid"
            );
        }

        USession session = ifsession.get();

        if (jwtUtil.ifJwtExpired(session.getCreatedTime())) {
            throw new JwtException(
                    jwtPropertiesConfig.getExpired(),
                    "jwt lifetime has ended, get a new one by refresh token"
            );
        }

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.USER.getName()))) {
            throw new RightsException(
                    rightsPropertiesConfig.getNorights(),
                    "only user can unsub or sub plant"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            throw new ObjectException(
                    objectPropertiesConfig.getFloranotfound(),
                    "flora to subscribe not found"
            );
        }

        Flora flora = ifflora.get();
        MafUser user = session.getUser();

        int floraIndex = -1;

        for (int i = 0; i < user.getTrackedPlants().size(); i++) {
            if (user.getTrackedPlants().get(i).getName().equals(flora.getName())) {
                floraIndex = i;
                break;
            }
        }

        if (floraIndex > -1) {
            user.getTrackedPlants().remove(floraIndex);
        } else {
            user.getTrackedPlants().add(flora);
        }
        mafUserRepository.save(user);
        return new StringDto(floraName);
    }

}
