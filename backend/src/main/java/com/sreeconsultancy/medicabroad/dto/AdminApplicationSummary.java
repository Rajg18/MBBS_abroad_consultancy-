package com.sreeconsultancy.medicabroad.dto;

import java.time.Instant;
import java.util.List;

/** One applicant row on the admin dashboard. */
public record AdminApplicationSummary(
        String id,
        String fullName,
        String phone,
        String email,
        String neetScore,
        String status,
        Instant createdAt,
        List<String> countries,   // priority order
        List<String> colleges,    // priority order, resolved names
        List<AdminDocumentInfo> documents
) {
}
