package com.sreeconsultancy.medicabroad.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * Payload the admin panel sends when creating or editing a college.
 * Optional fields fall back to sensible defaults in the service.
 */
public record CollegeAdminRequest(
        @NotBlank(message = "College name is required") String name,
        @NotBlank(message = "Country is required") String country,
        String program,
        String level,
        String intake,
        Boolean admissionOpen
) {
}
