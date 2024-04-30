package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "rights")
public class RightsPropertiesConfig {

    private String norights;

}
