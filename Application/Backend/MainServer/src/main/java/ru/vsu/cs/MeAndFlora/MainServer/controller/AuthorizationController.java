package ru.vsu.cs.MeAndFlora.MainServer.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.web.bind.annotation.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ObjectPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.*;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller responsible for user authorization and working with sessions and tokens")
@RequestMapping(path = "/auth")
class AuthorizationController {

    public static final Logger authorizationLogger =
            LoggerFactory.getLogger(AuthorizationController.class);

    private final AuthorizationService authorizationService;

    private final ObjectPropertiesConfig objectPropertiesConfig;

    @Operation(description = "Post. User registration and automatic login. Requires: NamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/register",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<MultiValueMap<String, Object>> register(
            @RequestPart @Schema(type = MediaType.APPLICATION_JSON_VALUE) byte[] namedAuthDto
    ) {

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            ObjectMapper mapper = new ObjectMapper();

            NamedAuthDto realNamedAuthDto = null;

            try {
                realNamedAuthDto = mapper.readValue(namedAuthDto, NamedAuthDto.class);
            } catch (IOException e) {
                throw new InputException(objectPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            DiJwtDto responseDto = authorizationService.register(
                    realNamedAuthDto.getLogin(), realNamedAuthDto.getPassword(), realNamedAuthDto.getIpAddress()
            );

            authorizationLogger.info(
                    "Register with username: " + realNamedAuthDto.getLogin() + " is successful"
            );

            body.add("diJwtDto", responseDto);

            status = HttpStatus.OK;

        } catch (AuthException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body.add("exceptionDto", exceptionDto);

            status = e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, status);

    }

    @Operation(description = "Post. User login. Requires: NamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/login",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<MultiValueMap<String, Object>> login(
            @RequestPart @Schema(type = MediaType.APPLICATION_JSON_VALUE) byte[] namedAuthDto
    ) {

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            ObjectMapper mapper = new ObjectMapper();

            NamedAuthDto realNamedAuthDto = null;

            try {
                realNamedAuthDto = mapper.readValue(namedAuthDto, NamedAuthDto.class);
            } catch (IOException e) {
                throw new InputException(objectPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            DiJwtDto responseDto = authorizationService.login(
                    realNamedAuthDto.getLogin(), realNamedAuthDto.getPassword(), realNamedAuthDto.getIpAddress()
            );

            authorizationLogger.info(
                    "Login with username: " + realNamedAuthDto.getLogin() + " is successful"
            );

            body.add("diJwtDto", responseDto);

            status = HttpStatus.OK;

        } catch (AuthException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body.add("exceptionDto", exceptionDto);

            status = e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, status);

    }

    @Operation(description = "Post. Anonymous login. Requires: UnnamedAuthDto in body."
            + "Provides: DiJwtDto in body.")
    @PostMapping(
            value = "/anonymous",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<MultiValueMap<String, Object>> anonymousLogin(
            @RequestPart @Schema(type = MediaType.APPLICATION_JSON_VALUE) byte[] unnamedAuthDto
    ) {

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            ObjectMapper mapper = new ObjectMapper();

            UnnamedAuthDto realUnnamedAuthDto = null;

            try {
                realUnnamedAuthDto = mapper.readValue(unnamedAuthDto, UnnamedAuthDto.class);
            } catch (IOException e) {
                throw new InputException(objectPropertiesConfig.getInvalidinput(), e.getMessage());
            }

            DiJwtDto responseDto = authorizationService.anonymousLogin(realUnnamedAuthDto.getIpAddress());

            authorizationLogger.info(
                    "Anonymus login on ip: " + realUnnamedAuthDto.getIpAddress() + " is successful"
            );

            body.add("diJwtDto", responseDto);

            status = HttpStatus.OK;

        } catch (AuthException | InputException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body.add("exceptionDto", exceptionDto);

            status = e.getClass() == AuthException.class ?
                    HttpStatus.UNAUTHORIZED : e.getClass() == InputException.class ?
                    HttpStatus.BAD_REQUEST : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, status);

    }

    @Operation(description = "Get. Get fresh jwt and refresh jwt (jwtr). Requires: jwtr in header."
            + "Provides: DiJwtDto in body.")
    @GetMapping(
            value = "/refresh",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<MultiValueMap<String, Object>> refresh(
            @RequestHeader String jwtr
    ) {

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            DiJwtDto responseDto = authorizationService.refresh(jwtr);

            authorizationLogger.info(
                    "Refresh token: " + jwtr + " has worked successfully"
            );

            body.add("diJwtDto", responseDto);

            status = HttpStatus.OK;

        } catch (JwtException e) {

            ExceptionDto exceptionDto =
                    new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(e.getShortMessage() + ": " + e.getMessage());

            body.add("exceptionDto", exceptionDto);

            status = e.getClass() == JwtException.class ?
                    HttpStatus.UNAUTHORIZED : HttpStatus.INTERNAL_SERVER_ERROR;

        }

        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, status);

    }

}