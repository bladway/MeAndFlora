package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.ImageUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.component.JwtUtil;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.MafUserRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;

import java.net.MalformedURLException;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {
    @Value("${application.images.getpath}")
    private String getpath;

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final FloraRepository floraRepository;

    private final USessionRepository uSessionRepository;

    private final MafUserRepository mafUserRepository;

    private final JwtUtil jwtUtil;

    private final ImageUtil fileUtil;

    @Override
    public Resource downloadFileWithAuth(String jwt, String filePath) {
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

        Resource resource;
        try {
            resource = fileUtil.getImage(filePath);
        } catch (MalformedURLException e) {
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotfound(),
                    "invalid url"
            );
        }

        return resource;

    }

    @Override
    public Resource downloadFile(String filePath) {
        Resource resource;

        try {
            resource = fileUtil.getImage(filePath);
        } catch (MalformedURLException e) {
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotfound(),
                    "invalid url"
            );
        }

        if (!resource.exists()) {
            throw new ObjectException(
                    errorPropertiesConfig.getImagenotfound(),
                    "image of this request not found"
            );
        }

        return resource;
    }

}
