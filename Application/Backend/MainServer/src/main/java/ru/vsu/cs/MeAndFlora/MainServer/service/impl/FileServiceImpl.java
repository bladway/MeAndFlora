package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;

import java.io.File;
import java.io.IOException;

@Service
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {

    @Value("${images.path}")
    private String path;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    @Override
    public Resource getImage(String path) {
        try {
            return new UrlResource(new File(this.path + path).toURI());
        } catch (IOException e) {
            throw new ObjectException(
                    objectPropertiesConfig.getImagenotfound(),
                    "server can't find image for existing flora"
            );
        }
    }

    @Override
    public void putImage(MultipartFile image, String path) {
        try {
            image.transferTo(new File(this.path + path).toPath());
        } catch (IOException e) {
            throw new ObjectException(
                    objectPropertiesConfig.getImagenotuploaded(),
                    "server can't save this uploaded image"
            );
        }
    }

}
