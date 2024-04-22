package ru.vsu.cs.MeAndFlora.MainServer.component;

import java.nio.charset.StandardCharsets;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtUtil {

    @Value("${jwt.password}")
    private String password;

    private Claims getClaimsIdFromToken(String token) {
        SecretKey key = Keys.hmacShaKeyFor(password.getBytes(StandardCharsets.UTF_8));
        return Jwts.parser()
            .verifyWith(key)
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }

    public String generateToken(Long sessionId) {
        SecretKey key = Keys.hmacShaKeyFor(password.getBytes(StandardCharsets.UTF_8));
        return Jwts.builder()
            .claim("sessionId", sessionId.toString())
            .signWith(key)
            .compact();
    }

    public Long getSessionIdFromToken(String token) {
        return getClaimsIdFromToken(token).get("sessionId", Long.class);
    }
    
}
