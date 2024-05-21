package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;

@Service
@RequiredArgsConstructor
public class FileUtil {

    @Value("${application.images.path}")
    private String path;

    public Resource getImage(String path) throws MalformedURLException {

            return new UrlResource(new File(this.path + path).toURI());

    }

    public void putImage(MultipartFile image, String path) throws IOException {

            image.transferTo(new File(this.path + path).toPath());

    }

}
