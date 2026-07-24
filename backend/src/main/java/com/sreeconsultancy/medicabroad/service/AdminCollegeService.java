package com.sreeconsultancy.medicabroad.service;

import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.sreeconsultancy.medicabroad.dto.CollegeAdminRequest;
import com.sreeconsultancy.medicabroad.dto.CollegeResponse;
import com.sreeconsultancy.medicabroad.model.College;
import com.sreeconsultancy.medicabroad.repository.CollegeRepository;

/**
 * Admin CRUD over the college catalogue, so the client can add/edit colleges
 * and open or close admissions without any code change or redeploy.
 */
@Service
public class AdminCollegeService {

    private static final Logger log = LoggerFactory.getLogger(AdminCollegeService.class);

    private final CollegeRepository repository;

    public AdminCollegeService(CollegeRepository repository) {
        this.repository = repository;
    }

    /** All colleges (including closed ones) for the admin table. */
    public List<CollegeResponse> listAll() {
        return repository.findAllByOrderByIdAsc().stream()
                .map(CollegeResponse::from)
                .toList();
    }

    @Transactional
    public CollegeResponse create(CollegeAdminRequest req) {
        College c = new College();
        c.setId("cust-" + UUID.randomUUID().toString().substring(0, 8));
        apply(c, req);
        repository.save(c);
        log.info("[ADMIN] College created: {} ({})", c.getName(), c.getId());
        return CollegeResponse.from(c);
    }

    @Transactional
    public CollegeResponse update(String id, CollegeAdminRequest req) {
        College c = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "College not found: " + id));
        apply(c, req);
        repository.save(c);
        log.info("[ADMIN] College updated: {} ({})", c.getName(), c.getId());
        return CollegeResponse.from(c);
    }

    @Transactional
    public void delete(String id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "College not found: " + id);
        }
        repository.deleteById(id);
        log.info("[ADMIN] College deleted: {}", id);
    }

    private void apply(College c, CollegeAdminRequest req) {
        c.setName(req.name().trim());
        c.setCountry(req.country().trim());
        c.setProgram(orDefault(req.program(), "General Medicine"));
        c.setLevel(orDefault(req.level(), "Bachelor"));
        c.setIntake(orDefault(req.intake(), "Sep-26"));
        c.setAdmissionOpen(req.admissionOpen() == null || req.admissionOpen());
    }

    private static String orDefault(String value, String fallback) {
        return (value == null || value.isBlank()) ? fallback : value.trim();
    }
}
