package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.common.header.Header;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class KafkaConsumer {

    private static final Logger kafkaConsumerLogger =
            LoggerFactory.getLogger(KafkaConsumer.class);

    private final USessionRepository uSessionRepository;

    private final ProcRequestRepository procRequestRepository;

    private final FloraRepository floraRepository;

    private final ObjectMapper objectMapper;

    public static final Map<Long, String> procReturnFloraNames = new HashMap<>();

    @KafkaListener(topics = "${spring.kafka.consumer.topic}", groupId = "${spring.kafka.consumer.group-id}")
    public void getProcReturnMessage(ConsumerRecord<Integer, String> record) {

        boolean jwtGood = false;
        boolean requestIdGood = false;
        Header[] headers = record.headers().toArray();
        String jwt;
        Long requestId = null;
        for (Header header : headers) {
            switch (header.key()) {
                case "jwt":
                    try {

                        jwt = new String(header.value(), StandardCharsets.UTF_8);

                        Optional<USession> ifsession = uSessionRepository.findByJwt(jwt);

                        jwtGood = ifsession.isPresent();

                    } catch (Exception ignored) {}
                    break;

                case "requestId":
                    try {

                        requestId = objectMapper.readValue(header.value(), Long.class);

                        Optional<ProcRequest> ifprocRequest = procRequestRepository.findById(requestId);

                        requestIdGood = ifprocRequest.isPresent() &&
                                ifprocRequest.get().getStatus().equals(ProcRequestStatus.NEURAL_PROC.getName());

                    } catch (Exception ignored) {}
                    break;
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
            kafkaConsumerLogger.info("accepted return message from broker with requestId {}", requestId);
        }

    }


}
