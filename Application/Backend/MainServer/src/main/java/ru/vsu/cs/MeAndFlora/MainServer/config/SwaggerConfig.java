package ru.vsu.cs.MeAndFlora.MainServer.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;

@OpenAPIDefinition(
    info = @Info(
        contact = @Contact(
            name = "bladway",
            email = "shepliakov_vlad@mail.ru",
            url = "https://github.com/bladway"
        ),
        description = "Swagger documentation for MeAndFlora-MainServer",
        title = "Swagger - MainServer",
        version = "${MAINSERVER_VERSION}"
    ) 
)
public class SwaggerConfig {

}
