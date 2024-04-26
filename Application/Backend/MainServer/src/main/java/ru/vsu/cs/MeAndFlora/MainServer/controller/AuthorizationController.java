package ru.vsu.cs.MeAndFlora.MainServer.controller;

import org.springframework.web.bind.annotation.RestController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.AuthException;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.DiJwtDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.NamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.UnnamedAuthDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.AuthorizationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;

@RequiredArgsConstructor
@RestController
@Tag(name = "Сontroller responsible for user authorization and working with sessions and tokens")
@RequestMapping(path = "/auth")
class AuthorizationController {

    public static final Logger authorizationLogger = 
        LoggerFactory.getLogger(AuthorizationController.class);

    private final AuthorizationService authorizationService;

    @Operation(description = "Post. User registration and authomatic login. Requires: NamedAuthDto in body."
    + "Provides: DiJwtDto in body.")
    @PostMapping(
        value = "/register",
        consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
        produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<?> register(@RequestPart NamedAuthDto authDto) {
        try {

            DiJwtDto responseDto = authorizationService.register(authDto.getLogin(), authDto.getPassword(), authDto.getIpAddress());

            authorizationLogger.info(
                "Register with username: " + authDto.getLogin() + " is successful"
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("diJwtDto", responseDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.OK);

        } catch (AuthException e) {

            ExceptionDto exceptionDto = 
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "Register with username: " + authDto.getLogin() + " failed with message: " + e.getMessage()
            );
            
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.UNAUTHORIZED);

        }
    }

    @Operation(description = "Post. User login. Requires: NamedAuthDto in body."
    + "Provides: DiJwtDto in body.")
    @PostMapping(
        value = "/login",
        consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
        produces = {MediaType.MULTIPART_FORM_DATA_VALUE}
    )
    public ResponseEntity<?> login(@RequestPart NamedAuthDto authDto) {
        try {

            DiJwtDto responseDto = authorizationService.login(authDto.getLogin(), authDto.getPassword(), authDto.getIpAddress());

            authorizationLogger.info(
                "Login with username: " + authDto.getLogin() + " is successful"
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("diJwtDto", responseDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.OK);

        } catch (AuthException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "Login with username: " + authDto.getLogin() + " failed with message: " + e.getMessage()
            );
            
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.UNAUTHORIZED);

        }
    }

    @Operation(description = "Post. Anonymous login. Requires: UnnamedAuthDto in body."
    + "Provides: DiJwtDto in body.")
    @PostMapping(
        value = "/anonymous"
    )
    public ResponseEntity<?> anonymousLogin(@RequestPart UnnamedAuthDto authDto) {
        try {

            DiJwtDto responseDto = authorizationService.anonymousLogin(authDto.getIpAddress());

            authorizationLogger.info(
                "Anonymus login on ip: " + authDto.getIpAddress() + " is successful"
            );
            
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("diJwtDto", responseDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.OK);

        } catch (AuthException e) {

            ExceptionDto exceptionDto =
                new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());

            authorizationLogger.warn(
                "Anonymous login on ip: " + authDto.getIpAddress() + " failed with message: " + e.getMessage()
            );
            
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.UNAUTHORIZED);

        }
    }

    @Operation(description = "Get. Get fresh jwt and refresh jwt (jwtr). Requires: jwtr in header."
    + "Provides: DiJwtDto in body.")
    @GetMapping(
        value = "/refresh",
        consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
        produces = {MediaType.MULTIPART_FORM_DATA_VALUE}    
    )
    public ResponseEntity<?> refresh(@RequestPart String jwtr) {
        try {

            DiJwtDto responseDto = authorizationService.refresh(jwtr);

            authorizationLogger.info(
                "Refresh token: " + jwtr + " has worked successfully"
            );

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("diJwtDto", responseDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.OK);

        } catch (JwtException e) {

            ExceptionDto exceptionDto = 
            new ExceptionDto(e.getShortMessage(), e.getMessage(), e.getTimestamp());
    
            authorizationLogger.warn(
                "problem with refresh jwt: " + jwtr + " message: " + e.getMessage()
            );
            
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("exceptionDto", exceptionDto);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            return new ResponseEntity<MultiValueMap<String, Object>>(body, headers, HttpStatus.UNAUTHORIZED);

        }
    }
    
}