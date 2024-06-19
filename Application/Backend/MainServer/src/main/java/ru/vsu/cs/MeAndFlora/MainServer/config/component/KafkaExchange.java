package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.header.Header;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.requestreply.CorrelationKey;
import org.springframework.kafka.requestreply.ReplyingKafkaTemplate;
import org.springframework.kafka.requestreply.RequestReplyFuture;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.config.states.ProcRequestStatus;
import ru.vsu.cs.MeAndFlora.MainServer.repository.FloraRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.ProcRequestRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.USessionRepository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.function.Function;

@Component
@RequiredArgsConstructor
public class KafkaExchange {

    @Value("${spring.kafka.producer.topic}")
    private String requestTopic;

    private static final Logger kafkaExchangeLogger =
            LoggerFactory.getLogger(KafkaExchange.class);

    private final ReplyingKafkaTemplate<Integer, byte[], String> replyingKafkaTemplate;

    private final USessionRepository uSessionRepository;

    private final ProcRequestRepository procRequestRepository;

    private final FloraRepository floraRepository;

    private final ObjectMapper objectMapper;

    public String processMessage(String requestJwt, MultipartFile image, ProcRequest procRequest) throws IOException, ExecutionException, InterruptedException, TimeoutException {
        Integer partition =
                Math.toIntExact(
                        procRequest.getSession().getUser() == null ?
                                0 : (procRequest.getSession().getUser().getUserId() % 4 + 1));

        ProducerRecord<Integer, byte[]> requestRecord = new ProducerRecord<>(requestTopic, partition, partition, image.getBytes());
        requestRecord.headers().add("jwt", requestJwt.getBytes());

        replyingKafkaTemplate.setCorrelationIdStrategy(new Function<ProducerRecord<Integer, byte[]>, CorrelationKey>() {
            @Override
            public CorrelationKey apply(ProducerRecord<Integer, byte[]> integerProducerRecord) {
                return new CorrelationKey(procRequest.getRequestId().toString().getBytes());
            }
        });

        RequestReplyFuture<Integer, byte[], String> replyFuture = replyingKafkaTemplate.sendAndReceive(requestRecord);
        kafkaExchangeLogger.info("message with requestId {} sent to broker", procRequest.getRequestId());

        ConsumerRecord<Integer, String> returnRecord = replyFuture.get(15, TimeUnit.SECONDS);

        boolean jwtGood = false;
        boolean requestIdGood = false;
        Header[] headers = returnRecord.headers().toArray();
        String returnJwt;
        Long returnRequestId = null;
        for (Header header : headers) {
            switch (header.key()) {
                case "jwt":
                    try {

                        returnJwt = new String(header.value(), StandardCharsets.UTF_8);

                        Optional<USession> ifsession = uSessionRepository.findByJwt(returnJwt);

                        jwtGood = ifsession.isPresent();

                    } catch (Exception ignored) {}
                    break;

                case "requestId":
                    try {

                        returnRequestId = objectMapper.readValue(header.value(), Long.class);

                        Optional<ProcRequest> ifprocRequest = procRequestRepository.findById(returnRequestId);

                        requestIdGood = ifprocRequest.isPresent() &&
                                ifprocRequest.get().getStatus().equals(ProcRequestStatus.NEURAL_PROC.getName());

                    } catch (Exception ignored) {}
                    break;
            }
        }

        String floraName = returnRecord.value();
        Optional<Flora> ifflora = floraRepository.findByName(floraName);
        boolean floraNameGood = ifflora.isPresent();

        if (!jwtGood) {
            kafkaExchangeLogger.warn("provided from broker jwt not good");
        } else if (!requestIdGood) {
            kafkaExchangeLogger.warn("provided from broker requestId not good");
        } else if (!floraNameGood) {
            kafkaExchangeLogger.warn("provided from broker floraName not good");
        } else {
            kafkaExchangeLogger.info("accepted return message from broker with requestId {}", returnRequestId);
            return floraName;
        }

        return null;
    }

}
