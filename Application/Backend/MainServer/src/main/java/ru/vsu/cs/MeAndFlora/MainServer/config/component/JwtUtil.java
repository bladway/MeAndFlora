package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.OffsetDateTime;
import javax.crypto.SecretKey;

import org.springframework.stereotype.Component;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;

@Component
@RequiredArgsConstructor
public class JwtUtil {

    private final JwtPropertiesConfig jwtPropertiesConfig;

    public String generateToken(Long sessionId) {
        SecretKey key = Keys.hmacShaKeyFor(jwtPropertiesConfig.getPassword().getBytes(StandardCharsets.UTF_8));
        return Jwts.builder()
                .claim("type", "access")
                .claim("sessionId", sessionId.toString())
                .signWith(key)
                .compact();
    }

    public String generateRToken(Long sessionId) {
        SecretKey key = Keys.hmacShaKeyFor(jwtPropertiesConfig.getPasswordr().getBytes(StandardCharsets.UTF_8));
        return Jwts.builder()
                .claim("type", "refresh")
                .claim("sessionId", sessionId.toString())
                .signWith(key)
                .compact();
    }

    public boolean ifJwtExpired(OffsetDateTime createdTime) {
        if (Duration.between(createdTime, OffsetDateTime.now()).compareTo(jwtPropertiesConfig.getLifetime()) > 0) {
            return true;
        } else {
            return false;
        }
    }

    public boolean ifJwtRExpired(OffsetDateTime createdTime) {
        if (Duration.between(createdTime, OffsetDateTime.now()).compareTo(jwtPropertiesConfig.getLifetimer()) > 0) {
            return true;
        } else {
            return false;
        }
    }

}
