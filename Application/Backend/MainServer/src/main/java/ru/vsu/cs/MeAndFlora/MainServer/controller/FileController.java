package ru.vsu.cs.MeAndFlora.MainServer.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.service.AdvertisementService;
import ru.vsu.cs.MeAndFlora.MainServer.service.FileService;
import ru.vsu.cs.MeAndFlora.MainServer.service.UserService;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with file")
@RequestMapping(path = "/file")
public class FileController {

    private static final Logger fileLogger =
            LoggerFactory.getLogger(FileController.class);

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final FileService fileService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Get. Get image."
            + " Requires: jwt in header, image path in query param"
            + " Provides: multipart image in body (jpg)")
    @GetMapping(
            value = "/download"
    )
    private ResponseEntity<Object> getProcessingRequest(
            @RequestHeader String jwt,
            @RequestParam String imagePath
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = fileService.downloadFile(jwt, imagePath);

            headers.setContentType(MediaType.IMAGE_JPEG);

            status = HttpStatus.OK;

            fileLogger.info(
                    "Get file by path: {} successful",
                    imagePath
            );

        } catch (CustomRuntimeException e) {

            body = new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            status = e.getClass() == AuthException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == InputException.class ? HttpStatus.BAD_REQUEST
                    : e.getClass() == JwtException.class ? HttpStatus.UNAUTHORIZED
                    : e.getClass() == ObjectException.class ? HttpStatus.NOT_FOUND
                    : e.getClass() == RightsException.class ? HttpStatus.FORBIDDEN
                    : e.getClass() == StateException.class ? HttpStatus.CONFLICT
                    : HttpStatus.INTERNAL_SERVER_ERROR;

            fileLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

}
