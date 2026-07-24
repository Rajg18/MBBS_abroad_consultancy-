package com.sreeconsultancy.medicabroad.security;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.stereotype.Service;

import com.sreeconsultancy.medicabroad.config.AdminProperties;

import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

/** Issues and validates the admin session JWT. */
@Service
public class JwtService {

    private final SecretKey key;
    private final long expiryMillis;

    public JwtService(AdminProperties props) {
        this.key = Keys.hmacShaKeyFor(props.getJwtSecret().getBytes(StandardCharsets.UTF_8));
        this.expiryMillis = props.getSessionHours() * 3_600_000L;
    }

    public String issue(String subject) {
        Instant now = Instant.now();
        return Jwts.builder()
                .subject(subject)
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plusMillis(expiryMillis)))
                .signWith(key)
                .compact();
    }

    /** True if the token is well-formed, correctly signed and not expired. */
    public boolean isValid(String token) {
        try {
            Jwts.parser().verifyWith(key).build().parseSignedClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }
}
