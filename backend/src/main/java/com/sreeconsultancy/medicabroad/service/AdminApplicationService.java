package com.sreeconsultancy.medicabroad.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.sreeconsultancy.medicabroad.dto.AdminApplicationSummary;
import com.sreeconsultancy.medicabroad.dto.AdminDocumentInfo;
import com.sreeconsultancy.medicabroad.model.Application;
import com.sreeconsultancy.medicabroad.model.ApplicationDocument;
import com.sreeconsultancy.medicabroad.model.College;
import com.sreeconsultancy.medicabroad.model.DocType;
import com.sreeconsultancy.medicabroad.repository.ApplicationRepository;
import com.sreeconsultancy.medicabroad.repository.CollegeRepository;

/** Read/admin operations over submitted applications. */
@Service
public class AdminApplicationService {

    private final ApplicationRepository applicationRepository;
    private final CollegeRepository collegeRepository;

    public AdminApplicationService(ApplicationRepository applicationRepository,
                                   CollegeRepository collegeRepository) {
        this.applicationRepository = applicationRepository;
        this.collegeRepository = collegeRepository;
    }

    /** All applications, newest first, as dashboard rows. */
    @Transactional(readOnly = true)
    public List<AdminApplicationSummary> list() {
        return applicationRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(this::toSummary)
                .toList();
    }

    /** The stored document of the given type for an application (404 if missing). */
    @Transactional(readOnly = true)
    public ApplicationDocument findDocument(String applicationId, DocType docType) {
        Application app = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Application not found"));
        return app.getDocuments().stream()
                .filter(d -> d.getDocType() == docType)
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Document not found"));
    }

    private AdminApplicationSummary toSummary(Application app) {
        List<String> collegeNames = app.getPreferredCollegeIds().stream()
                .map(id -> collegeRepository.findById(id)
                        .map(College::getName).orElse(id))
                .toList();
        List<AdminDocumentInfo> docs = app.getDocuments().stream()
                .map(d -> new AdminDocumentInfo(
                        d.getDocType().name(), d.getOriginalName(), d.getSizeBytes()))
                .toList();
        // Copy the lazy collection into a plain list so it is fully loaded
        // inside this transaction (avoids LazyInitializationException at
        // JSON-serialization time). collegeNames/docs are already fresh lists.
        return new AdminApplicationSummary(
                app.getId(), app.getFullName(), app.getPhone(), app.getEmail(),
                app.getNeetScore(), app.getStatus(), app.getCreatedAt(),
                List.copyOf(app.getPreferredCountries()), collegeNames, docs);
    }
}
