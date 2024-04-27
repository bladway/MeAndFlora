package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import lombok.Data;

@Data
@Configuration
@ConfigurationProperties(prefix = "jwt")
public class JwtPropertiesConfig {

    private String password;
    private String passwordr;
    private Duration lifetime;
    private Duration lifetimer;
    private String expired;
    private String expiredr;
    private String badjwt;
    private String badjwtr;

}
