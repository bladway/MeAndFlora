package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.core.io.Resource;

public interface FileService {

    Resource downloadFile(String jwt, String filePath);

}
