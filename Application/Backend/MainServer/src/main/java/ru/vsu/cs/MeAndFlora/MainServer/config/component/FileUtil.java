package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.ObjectException;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;

@Service
@RequiredArgsConstructor
public class FileUtil {

    @Value("${images.path}")
    private String path;

    private final ProcRequestRepository procRequestRepository;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    public Resource getImage(String path) throws MalformedURLException {

            return new UrlResource(new File(this.path + path).toURI());

    }

    public void putImage(MultipartFile image, String path) throws IOException {

            image.transferTo(new File(this.path + path).toPath());


    }

}
