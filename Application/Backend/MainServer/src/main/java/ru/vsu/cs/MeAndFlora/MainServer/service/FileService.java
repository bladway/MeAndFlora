package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileService {
    
    byte[] getImage(String path);
    void putImage(MultipartFile image, String imageName);

}
