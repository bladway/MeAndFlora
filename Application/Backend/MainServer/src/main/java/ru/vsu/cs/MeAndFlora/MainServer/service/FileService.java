package ru.vsu.cs.MeAndFlora.MainServer.service;

import org.springframework.core.io.Resource;

public interface FileService {

    Resource downloadFileWithAuth(String jwt, String filePath);

    Resource downloadFile(String filePath);

}
