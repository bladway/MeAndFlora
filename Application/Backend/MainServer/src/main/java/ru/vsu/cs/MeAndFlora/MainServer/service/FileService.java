package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

public interface FileService {

    Resource getImage(String path, ProcRequest deleteOnException);

    void putImage(MultipartFile image, String path, ProcRequest deleteOnException);

}
