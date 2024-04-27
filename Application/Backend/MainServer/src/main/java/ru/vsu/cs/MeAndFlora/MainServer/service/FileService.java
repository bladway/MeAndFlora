package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface FileService {

    Resource getImage(String path);

    void putImage(MultipartFile image, String path);

}
