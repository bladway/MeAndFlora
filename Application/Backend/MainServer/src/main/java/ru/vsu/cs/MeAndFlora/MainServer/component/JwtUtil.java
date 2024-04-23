package ru.vsu.cs.MeAndFlora.MainServer.component;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.OffsetDateTime;
import javax.crypto.SecretKey;
import org.springframework.stereotype.Component;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.config.JwtPropertiesConfig;
import ru.vsu.cs.MeAndFlora.MainServer.config.exception.JwtException;

@Component
@RequiredArgsConstructor
public class JwtUtil {

    private final JwtPropertiesConfig jwtPropertiesConfig;

    private Claims getClaimsIdFromToken(String token) {
        SecretKey key = Keys.hmacShaKeyFor(jwtPropertiesConfig.getPassword().getBytes(StandardCharsets.UTF_8));
        return Jwts.parser()
            .verifyWith(key)
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }

    public String generateToken(Long sessionId) {
        SecretKey key = Keys.hmacShaKeyFor(jwtPropertiesConfig.getPassword().getBytes(StandardCharsets.UTF_8));
        return Jwts.builder()
            .claim("sessionId", sessionId.toString())
            .signWith(key)
            .compact();
    }

    public Long getSessionIdFromToken(String token) {
        return getClaimsIdFromToken(token).get("sessionId", Long.class);
    }
    
    public boolean ifTokenExpired(OffsetDateTime createdTime) {
        if (Duration.between(createdTime, OffsetDateTime.now()).compareTo(jwtPropertiesConfig.getLifetime()) > 0) {
            return true;
        } else {
            return true;
        }
    }
}
