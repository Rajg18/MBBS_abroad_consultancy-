package com.sreeconsultancy.medicabroad.service;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sreeconsultancy.medicabroad.dto.ApplicationSubmissionRequest;
import com.sreeconsultancy.medicabroad.dto.SubmissionResponse;
import com.sreeconsultancy.medicabroad.model.Application;
import com.sreeconsultancy.medicabroad.model.ApplicationDocument;
import com.sreeconsultancy.medicabroad.model.College;
import com.sreeconsultancy.medicabroad.model.DocType;
import com.sreeconsultancy.medicabroad.repository.ApplicationRepository;
import com.sreeconsultancy.medicabroad.repository.CollegeRepository;
import com.sreeconsultancy.medicabroad.storage.StorageService;
import com.sreeconsultancy.medicabroad.web.BadRequestException;

/** Receives, validates, stores and persists student applications. */
@Service
public class ApplicationService {

    private static final long MAX_FILE_BYTES = 5L * 1024 * 1024; // 5 MB
    private static final Set<String> PDF_ONLY = Set.of("pdf");
    private static final Set<String> DOC_OR_IMAGE = Set.of("pdf", "jpg", "jpeg", "png");

    private final ApplicationRepository applicationRepository;
    private final CollegeRepository collegeRepository;
    private final StorageService storage;
    private final NotificationService notificationService;

    public ApplicationService(ApplicationRepository applicationRepository,
                              CollegeRepository collegeRepository,
                              StorageService storage,
                              NotificationService notificationService) {
        this.applicationRepository = applicationRepository;
        this.collegeRepository = collegeRepository;
        this.storage = storage;
        this.notificationService = notificationService;
    }

    @Transactional
    public SubmissionResponse submit(ApplicationSubmissionRequest req,
                                     MultipartFile tenthMarksheet,
                                     MultipartFile twelfthMarksheet,
                                     MultipartFile passport,
                                     MultipartFile aadhaar,
                                     MultipartFile neetScorecard) {

        // 1) Validate NEET score (int or float, 0..720).
        double score = parseScore(req.getNeetScore());
        if (score < 0 || score > 720) {
            throw new BadRequestException("NEET score must be between 0 and 720");
        }

        // 2) Validate the selected colleges actually exist.
        for (String id : req.getCollegeIds()) {
            if (!collegeRepository.existsById(id)) {
                throw new BadRequestException("Unknown college selected: " + id);
            }
        }

        // 3) Documents are optional; validate type + size for whatever was provided.
        validateFileIfPresent(tenthMarksheet, "10th marksheet", PDF_ONLY);
        validateFileIfPresent(twelfthMarksheet, "12th marksheet", PDF_ONLY);
        validateFileIfPresent(passport, "Passport", DOC_OR_IMAGE);
        validateFileIfPresent(aadhaar, "Aadhaar", DOC_OR_IMAGE);
        validateFileIfPresent(neetScorecard, "NEET scorecard", PDF_ONLY);

        // 4) Build the application and store its documents.
        String appId = UUID.randomUUID().toString();
        Application app = new Application();
        app.setId(appId);
        app.setFullName(req.getFullName().trim());
        app.setPhone(req.getPhone().trim());
        app.setEmail(req.getEmail().trim());
        app.setNeetScore(req.getNeetScore().trim());
        app.setConsent(req.isConsent());
        app.setPreferredCountries(req.getCountries());
        app.setPreferredCollegeIds(req.getCollegeIds());

        if (isPresent(tenthMarksheet)) {
            app.getDocuments().add(storeDoc(tenthMarksheet, appId, DocType.TENTH_MARKSHEET));
        }
        if (isPresent(twelfthMarksheet)) {
            app.getDocuments().add(storeDoc(twelfthMarksheet, appId, DocType.TWELFTH_MARKSHEET));
        }
        if (isPresent(passport)) {
            app.getDocuments().add(storeDoc(passport, appId, DocType.PASSPORT));
        }
        if (isPresent(aadhaar)) {
            app.getDocuments().add(storeDoc(aadhaar, appId, DocType.AADHAAR));
        }
        if (isPresent(neetScorecard)) {
            app.getDocuments().add(storeDoc(neetScorecard, appId, DocType.NEET_SCORECARD));
        }

        applicationRepository.save(app);

        // Notify the admin (async — never blocks or fails the submission).
        List<String> collegeNames = req.getCollegeIds().stream()
                .map(id -> collegeRepository.findById(id)
                        .map(College::getName).orElse(id))
                .toList();
        notificationService.notifyNewApplication(new NotificationPayload(
                appId, app.getFullName(), app.getPhone(), app.getEmail(),
                app.getPreferredCountries(), collegeNames));

        return new SubmissionResponse(appId, "NEW",
                "Application submitted successfully");
    }

    private ApplicationDocument storeDoc(MultipartFile file, String appId, DocType type) {
        String key = storage.store(file, appId, type.name());
        return new ApplicationDocument(type, key,
                file.getOriginalFilename(), file.getContentType(), file.getSize());
    }

    private static double parseScore(String raw) {
        try {
            return Double.parseDouble(raw.trim());
        } catch (NumberFormatException e) {
            throw new BadRequestException("NEET score must be a number");
        }
    }

    private static boolean isPresent(MultipartFile file) {
        return file != null && !file.isEmpty();
    }

    private static void validateFileIfPresent(MultipartFile file, String label, Set<String> allowedExt) {
        if (!isPresent(file)) {
            return; // documents are optional; nothing to validate
        }
        if (file.getSize() > MAX_FILE_BYTES) {
            throw new BadRequestException(label + " must be 5 MB or less");
        }
        String ext = extensionOf(file.getOriginalFilename());
        if (!allowedExt.contains(ext)) {
            throw new BadRequestException(
                    label + " must be one of: " + String.join(", ", sorted(allowedExt)));
        }
    }

    private static List<String> sorted(Set<String> s) {
        return s.stream().sorted().toList();
    }

    private static String extensionOf(String filename) {
        if (filename == null) return "";
        int dot = filename.lastIndexOf('.');
        return dot == -1 ? "" : filename.substring(dot + 1).toLowerCase();
    }
}
