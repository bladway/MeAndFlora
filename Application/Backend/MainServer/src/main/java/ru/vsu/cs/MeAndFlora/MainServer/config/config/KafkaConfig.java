package ru.vsu.cs.MeAndFlora.MainServer.config.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;
import org.springframework.kafka.requestreply.ReplyingKafkaTemplate;

import java.time.Duration;

@Configuration
public class KafkaConfig {

    @Value("${spring.kafka.producer.topic}")
    private String requestTopic;

    @Value("${spring.kafka.consumer.topic}")
    private String responseTopic;

    @Value("${spring.kafka.consumer.group-id}")
    private String groupId;

    @Bean
    public NewTopic procRequestTopic() {
        return new NewTopic(requestTopic, 5, (short) 1);
    }

    @Bean
    public NewTopic procReturnTopic() {
        return new NewTopic(responseTopic, 5, (short) 1);
    }

    @Bean
    public ReplyingKafkaTemplate<Integer, byte[], String> replyingKafkaTemplate(
            ProducerFactory<Integer, byte[]> producerFactory,
            ConcurrentKafkaListenerContainerFactory<Integer, String> concurrentKafkaListenerContainerFactory
    ) {
        ConcurrentMessageListenerContainer<Integer, String> concurrentMessageListenerContainer =
                concurrentKafkaListenerContainerFactory.createContainer(responseTopic);
        concurrentMessageListenerContainer.getContainerProperties().setGroupId(groupId);
        concurrentMessageListenerContainer.setAutoStartup(false);
        ReplyingKafkaTemplate<Integer, byte[], String> replyingKafkaTemplate =
                new ReplyingKafkaTemplate<>(producerFactory, concurrentMessageListenerContainer);
        replyingKafkaTemplate.setDefaultTopic(requestTopic);
        replyingKafkaTemplate.setCorrelationHeaderName("requestId");
        replyingKafkaTemplate.setDefaultReplyTimeout(Duration.ofSeconds(15));
        return replyingKafkaTemplate;
    }

}
