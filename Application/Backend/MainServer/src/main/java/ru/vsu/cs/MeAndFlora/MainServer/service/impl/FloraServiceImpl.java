package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.ImageUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.InputException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.RightsException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FloraServiceImpl implements FloraService {

    @Value("${application.images.getpath}")
    private String getpath;

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final FloraRepository floraRepository;

    private final USessionRepository uSessionRepository;

    private final MafUserRepository mafUserRepository;

    private final JwtUtil jwtUtil;

    private final ImageUtil fileUtil;

    private void validateFloraName(String floraName) {
        if (floraName.length() > 256) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "provided flora name size is incorrect"
            );
        }
    }

    private void validateFloraDescription(String floraDescription) {
        if (floraDescription.length() > 1000) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "provided flora description size is incorrect"
            );
        }
    }

    private void validateFloraType(String floraType) {
        if (floraType.length() > 128) {
            throw new InputException(
                    errorPropertiesConfig.getInvalidinput(),
                    "provided flora type size is incorrect"
            );
        }
    }

    @Override
    public FloraDto requestFlora(String jwt, String floraName) {
        validateFloraName(floraName);

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

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "admin has no rights to request flora"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            throw new ObjectException(
                    errorPropertiesConfig.getFloranotfound(),
                    "requested flora not found"
            );
        }

        Flora flora = ifflora.get();

        /*Resource resource;
        try {
            resource = fileUtil.getImage(flora.getImagePath());
        } catch (MalformedURLException e) {
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotfound(),
                    "requested image not found"
            );
        }*/

        boolean isSubscribed = false;
        if (session.getUser() != null) {
            for (Flora curFlora : session.getUser().getTrackedPlants()) {
                if (flora.getName().equals(curFlora.getName())) {
                    isSubscribed = true;
                    break;
                }
            }
        }

        return new FloraDto(
                flora.getName(),
                flora.getDescription(),
                flora.getType(),
                isSubscribed,
                flora.getImagePath()
        );

    }

    @Override
    public StringDto createFlora(String jwt, String floraName, String description, String type, MultipartFile image) {
        validateFloraName(floraName);
        validateFloraDescription(description);
        validateFloraType(type);

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

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.BOTANIST.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only botanist can create flora"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isPresent()) {
            throw new ObjectException(
                    errorPropertiesConfig.getDoubleflora(),
                    "requested to create flora already exists"
            );
        }

        try {
            fileUtil.putImage(image, getpath + floraName + ".jpg");
        } catch (IOException e) {
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotuploaded(),
                "server can't upload provided image"
            );
        }

        Flora flora = floraRepository.save(new Flora(getpath + floraName + ".jpg", floraName, description, type));

        return new StringDto(flora.getName());
    }

    @Override
    public StringsDto getTypes(String jwt, int page, int size) {
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

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "admin has no rights to get types of flora"
            );
        }

        Page<String> typePage = floraRepository.getTypesOfFlora(PageRequest.of(page, size));
        List<String> typeList = new ArrayList<>();
        typePage.forEach(type -> typeList.add(type));

        /*if (typeList.isEmpty()) {
            throw new ObjectException(
                    errorPropertiesConfig.getFloranotfound(),
                    "there are no typed flora"
            );
        }*/

        return new StringsDto(typeList);
    }

    @Override
    public StringsDto getFloraByType(String jwt, String floraType, int page, int size) {
        validateFloraType(floraType);

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

        if (session.getUser() != null && session.getUser().getRole().equals(UserRole.ADMIN.getName())) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "admin has no rights to get flora names by type"
            );
        }

        Page<Flora> floraList = floraRepository.findByType(floraType, PageRequest.of(page, size));
        List<String> floraNameList = new ArrayList<>();
        floraList.forEach(flora -> floraNameList.add(flora.getName()));

        /*if (floraNameList.isEmpty()) {
            throw new ObjectException(
                    errorPropertiesConfig.getFloranotfound(),
                    "there are no flora of requested type"
            );
        }*/

        return new StringsDto(floraNameList);
    }

    @Override
    public StringDto unsubOrSub(String jwt, String floraName) {
        validateFloraName(floraName);

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

        if (!(session.getUser() != null && session.getUser().getRole().equals(UserRole.USER.getName()))) {
            throw new RightsException(
                    errorPropertiesConfig.getNorights(),
                    "only user can unsub or sub plant"
            );
        }

        Optional<Flora> ifflora = floraRepository.findByName(floraName);

        if (ifflora.isEmpty()) {
            throw new ObjectException(
                    errorPropertiesConfig.getFloranotfound(),
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
