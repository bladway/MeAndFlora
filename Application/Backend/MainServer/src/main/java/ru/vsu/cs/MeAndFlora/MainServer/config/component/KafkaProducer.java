package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

@Component
@RequiredArgsConstructor
public class KafkaProducer {

    @Value("${spring.kafka.producer.topic}")
    private String requestTopic;

    private final KafkaTemplate<Integer, byte[]> kafkaTemplate;

    public void sendProcRequestMessage(String jwt, byte[] image, ProcRequest procRequest) {
        Integer partition = procRequest.getSession().getUser() == null ? 1 : (procRequest.getSession().getUser().getLogin().hashCode() % 4 + 2);
        ProducerRecord<Integer, byte[]> record = new ProducerRecord<>(requestTopic, partition, partition, image);
        record.headers().add("jwt", jwt.getBytes());
        record.headers().add("requestId", procRequest.getRequestId().toString().getBytes());
        kafkaTemplate.send(record);
    }

}
