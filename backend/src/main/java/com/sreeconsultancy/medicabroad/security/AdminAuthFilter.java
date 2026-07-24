package com.sreeconsultancy.medicabroad.security;

import java.io.IOException;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Guards the admin API: every {@code /api/admin/**} request (except the login
 * and CORS preflight) must carry a valid {@code Authorization: Bearer <jwt>}.
 */
@Component
public class AdminAuthFilter extends OncePerRequestFilter {

    private final JwtService jwt;

    public AdminAuthFilter(JwtService jwt) {
        this.jwt = jwt;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        // Only guard admin endpoints...
        if (!path.startsWith("/api/admin")) return true;
        // ...but never the login endpoint or CORS preflight.
        if (path.equals("/api/admin/login")) return true;
        return "OPTIONS".equalsIgnoreCase(request.getMethod());
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        String header = request.getHeader("Authorization");
        String token = (header != null && header.startsWith("Bearer "))
                ? header.substring(7) : null;

        if (token == null || !jwt.isValid(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }
        chain.doFilter(request, response);
    }
}
