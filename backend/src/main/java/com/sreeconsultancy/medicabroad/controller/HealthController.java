package com.sreeconsultancy.medicabroad.controller;

import java.time.Instant;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Simple liveness endpoint used to confirm the API is up.
 * GET /api/health -> {"status":"UP", ...}
 */
@RestController
@RequestMapping("/api")
public class HealthController {

    @GetMapping("/health")
    public Map<String, Object> health() {
        return Map.of(
                "status", "UP",
                "service", "medic-abroad-backend",
                "time", Instant.now().toString()
        );
    }
}
