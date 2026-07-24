package com.sreeconsultancy.medicabroad.dto;

import jakarta.validation.constraints.NotBlank;

/** Admin login credentials. */
public record AdminLoginRequest(
        @NotBlank(message = "Username is required") String username,
        @NotBlank(message = "Password is required") String password
) {
}
