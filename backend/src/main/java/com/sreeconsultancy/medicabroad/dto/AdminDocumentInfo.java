package com.sreeconsultancy.medicabroad.dto;

/** Metadata for one downloadable document on the admin dashboard. */
public record AdminDocumentInfo(
        String docType,      // TENTH_MARKSHEET, TWELFTH_MARKSHEET, PASSPORT, AADHAAR
        String fileName,
        long sizeBytes
) {
}
