package com.sreeconsultancy.medicabroad.dto;

import com.sreeconsultancy.medicabroad.model.College;

/** What the API returns for a single college (all fields here are safe/public). */
public record CollegeResponse(
        String id,
        String name,
        String country,
        String program,
        String level,
        String intake,
        boolean admissionOpen
) {
    public static CollegeResponse from(College c) {
        return new CollegeResponse(
                c.getId(), c.getName(), c.getCountry(),
                c.getProgram(), c.getLevel(), c.getIntake(), c.isAdmissionOpen());
    }
}
