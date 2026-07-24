package com.sreeconsultancy.medicabroad.dto;

/** Returned on a successful admin login. */
public record AdminLoginResponse(String token, int expiresInHours) {
}
