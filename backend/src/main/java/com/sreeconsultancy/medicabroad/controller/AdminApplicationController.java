package com.sreeconsultancy.medicabroad.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sreeconsultancy.medicabroad.dto.AdminApplicationSummary;
import com.sreeconsultancy.medicabroad.model.ApplicationDocument;
import com.sreeconsultancy.medicabroad.model.DocType;
import com.sreeconsultancy.medicabroad.service.AdminApplicationService;
import com.sreeconsultancy.medicabroad.storage.StorageService;

/**
 * Admin dashboard endpoints. Everything under /api/admin/** is guarded by
 * {@code AdminAuthFilter} (requires a valid login JWT).
 *   GET /api/admin/applications
 *   GET /api/admin/applications/{id}/documents/{docType}
 */
@RestController
@RequestMapping("/api/admin")
public class AdminApplicationController {

    private static final Logger log = LoggerFactory.getLogger(AdminApplicationController.class);

    private final AdminApplicationService service;
    private final StorageService storage;

    public AdminApplicationController(AdminApplicationService service, StorageService storage) {
        this.service = service;
        this.storage = storage;
    }

    @GetMapping("/applications")
    public List<AdminApplicationSummary> applications() {
        return service.list();
    }

    @GetMapping("/applications/{id}/documents/{docType}")
    public ResponseEntity<Resource> download(@PathVariable String id,
                                             @PathVariable DocType docType) {
        ApplicationDocument doc = service.findDocument(id, docType);
        Resource resource = storage.loadAsResource(doc.getStorageKey());

        // Audit: every document view is logged (who/when handled by the access log).
        log.info("[ADMIN DOWNLOAD] application={} docType={} file={}",
                id, docType, doc.getOriginalName());

        String contentType = (doc.getContentType() == null || doc.getContentType().isBlank())
                ? MediaType.APPLICATION_OCTET_STREAM_VALUE : doc.getContentType();
        String downloadName = docType.name() + "-" + safeName(doc.getOriginalName());

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + downloadName + "\"")
                .body(resource);
    }

    private static String safeName(String name) {
        if (name == null || name.isBlank()) return "file";
        return name.replaceAll("[^a-zA-Z0-9._-]", "_");
    }
}
