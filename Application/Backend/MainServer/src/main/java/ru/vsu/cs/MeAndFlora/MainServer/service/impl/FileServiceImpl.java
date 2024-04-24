package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {
    
    @Value("${images.path}")
    private String path;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    @Override
    public byte[] getImage(String path) { 
        try {
            return Files.readAllBytes(new File(this.path + path).toPath());
        } catch (IOException e) {
            throw new ObjectException(
                objectPropertiesConfig.getImagenotfound(),
                "server can't find image for existing flora"
            );
        }
    }

}
