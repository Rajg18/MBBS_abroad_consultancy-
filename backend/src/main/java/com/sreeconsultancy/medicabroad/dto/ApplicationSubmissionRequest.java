package com.sreeconsultancy.medicabroad.dto;

import java.util.List;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/** Text fields of a submission (files are handled separately as multipart parts). */
@Data
public class ApplicationSubmissionRequest {

    @NotBlank(message = "Full name is required")
    private String fullName;

    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^(\\+?91[-\\s]?)?[6-9]\\d{9}$",
            message = "Enter a valid 10-digit Indian phone number")
    private String phone;

    @NotBlank(message = "Email is required")
    @Email(message = "Enter a valid email address")
    private String email;

    @NotBlank(message = "NEET score is required")
    private String neetScore;

    @NotEmpty(message = "Select at least one country")
    private List<String> countries;

    @NotEmpty(message = "Select at least one college")
    private List<String> collegeIds;

    @AssertTrue(message = "Consent is required to submit")
    private boolean consent;
}
