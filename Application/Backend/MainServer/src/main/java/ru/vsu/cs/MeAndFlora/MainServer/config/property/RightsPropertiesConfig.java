package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import lombok.Data;

@Data
@Configuration
@ConfigurationProperties(prefix = "rights")
public class RightsPropertiesConfig {

    private String norights;
    
}
