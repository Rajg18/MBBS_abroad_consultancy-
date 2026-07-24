package com.sreeconsultancy.medicabroad.security;

import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

/**
 * In-memory brute-force guard for the admin login: after {@value #MAX_FAILURES}
 * failed attempts from one IP, that IP is blocked for {@link #WINDOW}.
 */
@Component
public class LoginRateLimiter {

    private static final int MAX_FAILURES = 5;
    private static final Duration WINDOW = Duration.ofMinutes(15);

    private record Attempts(int count, Instant windowStart) {}

    private final Map<String, Attempts> byIp = new ConcurrentHashMap<>();

    public boolean isBlocked(String ip) {
        Attempts a = byIp.get(ip);
        if (a == null) return false;
        if (Instant.now().isAfter(a.windowStart().plus(WINDOW))) {
            byIp.remove(ip);
            return false;
        }
        return a.count() >= MAX_FAILURES;
    }

    public void recordFailure(String ip) {
        byIp.compute(ip, (k, a) -> {
            Instant now = Instant.now();
            if (a == null || now.isAfter(a.windowStart().plus(WINDOW))) {
                return new Attempts(1, now);
            }
            return new Attempts(a.count() + 1, a.windowStart());
        });
    }

    public void reset(String ip) {
        byIp.remove(ip);
    }
}
