package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;

@Data
@Configuration
@ConfigurationProperties(prefix = "application.jwt")
public class JwtPropertiesConfig {

    private String password;
    private String passwordr;
    private Duration lifetime;
    private Duration lifetimer;

}
