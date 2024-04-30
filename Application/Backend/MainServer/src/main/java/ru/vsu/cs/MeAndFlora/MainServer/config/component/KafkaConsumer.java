package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.common.header.Header;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import ru.vsu.cs.MeAndFlora.MainServer.MainServerApplication;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class KafkaConsumer {

    public static final Logger kafkaConsumerLogger =
            LoggerFactory.getLogger(KafkaConsumer.class);

    private final USessionRepository uSessionRepository;

    private final ProcRequestRepository procRequestRepository;

    private final FloraRepository floraRepository;

    public static final Map<Long, String> procReturnFloraNames = new HashMap<>();

    @KafkaListener(topics = "${spring.kafka.consumer.topic}", groupId = "${spring.kafka.consumer.group-id}")
    public void getProcReturnMessage(ConsumerRecord<Long, String> record) {

        boolean jwtGood = false;
        boolean requestIdGood = false;
        Header[] headers = record.headers().toArray();
        String jwt;
        Long requestId = null;
        for (Header header : headers) {
            switch (header.key()) {
                case "jwt":
                    try {

                        jwt = MainServerApplication.objectMapper.readValue(header.value(), String.class);

                        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

                        jwtGood = ifsession.isPresent();

                    } catch (Exception ignored) {}

                case "requestId":
                    try {

                        requestId = MainServerApplication.objectMapper.readValue(header.value(), Long.class);

                        Optional<ProcRequest> ifprocRequest = procRequestRepository.findById(requestId);

                        requestIdGood = ifprocRequest.isPresent() &&
                                ifprocRequest.get().getStatus().equals(ProcRequestStatus.NEURAL_PROC.getName());

                    } catch (Exception ignored) {}
            }
        }

        String floraName = record.value();
        Optional<Flora> ifflora = floraRepository.findByName(floraName);
        boolean floraNameGood = ifflora.isPresent();

        if (!jwtGood) {
            kafkaConsumerLogger.warn("provided from broker jwt not good");
        } else if (!requestIdGood) {
            kafkaConsumerLogger.warn("provided from broker requestId not good");
        } else if (!floraNameGood) {
            kafkaConsumerLogger.warn("provided from broker floraName not good");
        } else {
            procReturnFloraNames.put(requestId, floraName);
        }

    }


}