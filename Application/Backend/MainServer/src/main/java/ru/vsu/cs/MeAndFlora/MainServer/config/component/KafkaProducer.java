package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class KafkaProducer {

    @Value("${spring.kafka.producer.topic}")
    private String requestTopic;

    private static final Logger kafkaProducerLogger =
            LoggerFactory.getLogger(KafkaProducer.class);

    private final KafkaTemplate<Integer, byte[]> kafkaTemplate;

    public void sendProcRequestMessage(String jwt, MultipartFile image, ProcRequest procRequest) throws IOException {
        Integer partition =
                Math.toIntExact(
                        procRequest.getSession().getUser() == null ?
                                0 : (procRequest.getSession().getUser().getUserId() % 4 + 1));

        ProducerRecord<Integer, byte[]> record = new ProducerRecord<>(requestTopic, partition, partition, image.getBytes());
        record.headers().add("jwt", jwt.getBytes());
        record.headers().add("requestId", procRequest.getRequestId().toString().getBytes());

        kafkaTemplate.send(record);
        kafkaProducerLogger.info("message with requestId {} sent to broker", procRequest.getRequestId());
    }

}
