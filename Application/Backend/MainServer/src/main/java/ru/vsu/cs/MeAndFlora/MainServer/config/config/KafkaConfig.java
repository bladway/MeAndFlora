package ru.vsu.cs.MeAndFlora.MainServer.config.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KafkaConfig {

    @Value("${spring.kafka.producer.topic}")
    private String requestTopic;

    @Value("${spring.kafka.consumer.topic}")
    private String responseTopic;

    @Bean
    public NewTopic procRequestTopic() {
        return new NewTopic(requestTopic, 5, (short) 1);
    }

    @Bean
    public NewTopic procReturnTopic() {
        return new NewTopic(responseTopic, 5, (short) 1);
    }

}
