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
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.ExceptionDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.RequestService;

@RequiredArgsConstructor
@RestController
@Tag(name = "Controller for working with history")
@RequestMapping(path = "/history")
public class HistoryController {

    private static final Logger historyLogger =
            LoggerFactory.getLogger(HistoryController.class);

    private final RequestService requestService;

    private final ObjectMapper objectMapper;

    @Operation(description = "Get. Get all request(history) ids of the user."
            + " Requires: jwt in header, page and size in query params (optionally)."
            + " Provides: longsDto with sorted request ids in body (first is much latest).")
    @GetMapping(
            value = "/allByUser"
    )
    public ResponseEntity<Object> getWatchedPublications(
            @RequestHeader String jwt,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size
    ) {

        Object body;
        HttpHeaders headers = new HttpHeaders();
        HttpStatus status;

        try {

            body =  requestService.getHistory(jwt, page, size);

            status = HttpStatus.OK;

            historyLogger.info(
                    "Get user history, page: {}, with size: {} is successful",
                    page,
                    size
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

            historyLogger.warn("{}: {}", e.getShortMessage(), e.getMessage());

        }

        headers.add("jwt", jwt);

        return new ResponseEntity<>(body, headers, status);

    }

}
