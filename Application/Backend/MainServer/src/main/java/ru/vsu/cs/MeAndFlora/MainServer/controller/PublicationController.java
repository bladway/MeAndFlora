package ru.vsu.cs.MeAndFlora.MainServer.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.*;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.ErrorPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.LongDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with published requests")
@RequestMapping(path = "/publication")
public class PublicationController {

    private static final Logger publicationLogger =
            LoggerFactory.getLogger(PublicationController.class);

    private final ErrorPropertiesConfig errorPropertiesConfig;

    private final RequestService requestService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Post. Delete publication by admin."
            + " Requires: jwt in header, LongDto with requestId in body."
            + " Provides: LongDto with requestId of deleted publication.")
    @PostMapping(
            value = "/delete"
    )
    public ResponseEntity<Object> deleteUser(
            @RequestHeader String jwt,
            @RequestBody LongDto longDto
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body = requestService.deleteProcRequest(jwt, longDto.getNumber());

            status = HttpStatus.OK;

            publicationLogger.info(
                    "Delete publication with requestId: {} is successful",
                    longDto.getNumber()
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

            publicationLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

}
