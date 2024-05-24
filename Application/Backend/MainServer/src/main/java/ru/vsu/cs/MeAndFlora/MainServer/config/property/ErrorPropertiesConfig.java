package ru.vsu.cs.MeAndFlora.MainServer.config.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "application.error")
public class ErrorPropertiesConfig {

    private String expired;
    private String expiredr;
    private String badjwt;
    private String badjwtr;
    private String badlogin;
    private String badpassword;
    private String badip;
    private String usrnotfound;
    private String sessionidproblem;
    private String doublelogin;
    private String floranotfound;
    private String requestnotfound;
    private String imagenotfound;
    private String imagenotuploaded;
    private String invalidinput;
    private String changeisnull;
    private String neuraltimeout;
    private String doubleflora;
    private String norights;
    private String neuraltouserbad;
    private String usertoanotherbad;
    private String botanisttoanotherbad;
    private String limitsexceeded;
    private String badrequeststate;
    private String overloaded;

}
