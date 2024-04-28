package ru.vsu.cs.MeAndFlora.MainServer.config.config;


import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.KafkaTemplate;

@Configuration
public class KafkaConfig {

    @Value("${spring.kafka.producer.topic}")
    private String requestTopic;

    @Bean
    public NewTopic ProcRequestTopic() {
        return new NewTopic(requestTopic, 5, (short) 1);
    }

}
