package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "auth")
public class AuthPropertiesConfig {

    private String badlogin;
    private String badpassword;
    private String badip;
    private String usrnotfound;
    private String sessionidproblem;
    private String doublelogin;

}
