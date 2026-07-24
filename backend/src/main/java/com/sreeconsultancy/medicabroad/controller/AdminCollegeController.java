package com.sreeconsultancy.medicabroad.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sreeconsultancy.medicabroad.dto.CollegeAdminRequest;
import com.sreeconsultancy.medicabroad.dto.CollegeResponse;
import com.sreeconsultancy.medicabroad.service.AdminCollegeService;

import jakarta.validation.Valid;

/**
 * College management for the admin panel (all routes require the admin JWT —
 * enforced by AdminAuthFilter on /api/admin/**).
 *   GET    /api/admin/colleges        list every college
 *   POST   /api/admin/colleges        add a college
 *   PUT    /api/admin/colleges/{id}   edit / open / close a college
 *   DELETE /api/admin/colleges/{id}   remove a college
 */
@RestController
@RequestMapping("/api/admin/colleges")
public class AdminCollegeController {

    private final AdminCollegeService service;

    public AdminCollegeController(AdminCollegeService service) {
        this.service = service;
    }

    @GetMapping
    public List<CollegeResponse> list() {
        return service.listAll();
    }

    @PostMapping
    public ResponseEntity<CollegeResponse> create(@Valid @RequestBody CollegeAdminRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(request));
    }

    @PutMapping("/{id}")
    public CollegeResponse update(@PathVariable String id,
                                  @Valid @RequestBody CollegeAdminRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
