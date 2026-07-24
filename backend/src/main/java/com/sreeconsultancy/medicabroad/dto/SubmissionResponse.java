package com.sreeconsultancy.medicabroad.dto;

/** Returned after a successful submission. */
public record SubmissionResponse(String id, String status, String message) {
}
