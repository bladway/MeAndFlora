package ru.vsu.cs.MeAndFlora.MainServer.service.impl;

import java.nio.charset.StandardCharsets;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import ru.vsu.cs.MeAndFlora.MainServer.service.JwtService;


@Service
public class JwtServiceImpl implements JwtService{
    
    @Value("${jwt.password}")
    private String password;
    
    private SecretKey key = Keys.hmacShaKeyFor(password.getBytes(StandardCharsets.UTF_8));

    public String generateToken(Long sessionId) {
        return Jwts.builder()
            .claim("sessionId", sessionId.toString())
            .signWith(key)
            .compact();
    }

    public Claims getClaimsIdFromToken(String token) {
        return Jwts.parser()
            .verifyWith(key)
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }

    public Long getSessionId(String token) {
        return getClaimsIdFromToken(token).get("sessionId", Long.class);
    }

}
