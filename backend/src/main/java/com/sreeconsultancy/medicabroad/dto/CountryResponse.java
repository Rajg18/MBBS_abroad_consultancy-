package com.sreeconsultancy.medicabroad.dto;

/** A country grouping for the first selection step. */
public record CountryResponse(
        String name,
        String flag,
        long collegeCount,
        long openCount
) {
}
