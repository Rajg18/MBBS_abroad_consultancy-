package com.sreeconsultancy.medicabroad.controller;

import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sreeconsultancy.medicabroad.config.AdminProperties;
import com.sreeconsultancy.medicabroad.dto.AdminLoginRequest;
import com.sreeconsultancy.medicabroad.dto.AdminLoginResponse;
import com.sreeconsultancy.medicabroad.security.JwtService;
import com.sreeconsultancy.medicabroad.security.LoginRateLimiter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

/**
 * Admin login. Verifies a single username + password against the configured
 * BCrypt hash (or a dev plaintext password), rate-limits attempts, and returns
 * a session JWT used to access the protected /api/admin/** endpoints.
 */
@RestController
@RequestMapping("/api/admin")
public class AdminAuthController {

    private final AdminProperties props;
    private final JwtService jwt;
    private final LoginRateLimiter rateLimiter;
    private final PasswordEncoder encoder = new BCryptPasswordEncoder();

    public AdminAuthController(AdminProperties props, JwtService jwt,
                              LoginRateLimiter rateLimiter) {
        this.props = props;
        this.jwt = jwt;
        this.rateLimiter = rateLimiter;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody AdminLoginRequest req,
                                   HttpServletRequest http) {
        String ip = http.getRemoteAddr();

        if (rateLimiter.isBlocked(ip)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                    .body(Map.of("error", "Too many attempts. Try again in a few minutes."));
        }
        if (!props.isConfigured()) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                    .body(Map.of("error", "Admin login is not configured on the server."));
        }

        boolean ok = props.getUsername().equals(req.username()) && passwordMatches(req.password());
        if (!ok) {
            rateLimiter.recordFailure(ip);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid username or password"));
        }

        rateLimiter.reset(ip);
        String token = jwt.issue(props.getUsername());
        return ResponseEntity.ok(new AdminLoginResponse(token, props.getSessionHours()));
    }

    private boolean passwordMatches(String submitted) {
        if (!props.getPasswordHash().isBlank()) {
            return encoder.matches(submitted, props.getPasswordHash());
        }
        // Dev fallback: constant-time compare against the plaintext password.
        return constantTimeEquals(submitted, props.getPassword());
    }

    private static boolean constantTimeEquals(String a, String b) {
        return MessageDigest.isEqual(
                a.getBytes(StandardCharsets.UTF_8),
                b.getBytes(StandardCharsets.UTF_8));
    }
}
