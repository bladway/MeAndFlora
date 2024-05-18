package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "object")
public class ObjectPropertiesConfig {

    private String floranotfound;
    private String imagenotfound;
    private String imagenotuploaded;
    private String invalidinput;
    private String changeisnull;
    private String neuraltimeout;

}
