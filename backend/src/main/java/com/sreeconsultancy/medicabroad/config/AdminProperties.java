package com.sreeconsultancy.medicabroad.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.Setter;

/**
 * Admin panel login settings (bound from `admin.*` / environment).
 *
 * Production should set {@code passwordHash} (a BCrypt hash) and a strong
 * {@code jwtSecret} via environment variables. For local dev, a plaintext
 * {@code password} is accepted as a convenience.
 */
@Component
@ConfigurationProperties(prefix = "admin")
@Getter
@Setter
public class AdminProperties {

    private String username = "admin";

    /** BCrypt hash of the admin password (preferred, for production). */
    private String passwordHash = "";

    /** Plaintext password (dev convenience; ignored if passwordHash is set). */
    private String password = "";

    /** HMAC secret for signing session JWTs (must be >= 32 chars). */
    private String jwtSecret = "dev-only-change-me-please-min-32-characters!!";

    /** How long a login session (JWT) stays valid. */
    private int sessionHours = 12;

    public boolean isConfigured() {
        return !passwordHash.isBlank() || !password.isBlank();
    }
}
