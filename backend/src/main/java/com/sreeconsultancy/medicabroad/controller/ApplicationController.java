package com.sreeconsultancy.medicabroad.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.sreeconsultancy.medicabroad.dto.ApplicationSubmissionRequest;
import com.sreeconsultancy.medicabroad.dto.SubmissionResponse;
import com.sreeconsultancy.medicabroad.service.ApplicationService;

import jakarta.validation.Valid;

/**
 * Receives a student's application as multipart/form-data:
 * text fields + the four document files.
 *   POST /api/applications
 */
@RestController
@RequestMapping("/api")
public class ApplicationController {

    private final ApplicationService service;

    public ApplicationController(ApplicationService service) {
        this.service = service;
    }

    @PostMapping(value = "/applications", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<SubmissionResponse> submit(
            @Valid @ModelAttribute ApplicationSubmissionRequest request,
            @RequestParam("tenthMarksheet") MultipartFile tenthMarksheet,
            @RequestParam("twelfthMarksheet") MultipartFile twelfthMarksheet,
            @RequestParam("passport") MultipartFile passport,
            @RequestParam("aadhaar") MultipartFile aadhaar) {

        SubmissionResponse response = service.submit(
                request, tenthMarksheet, twelfthMarksheet, passport, aadhaar);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
