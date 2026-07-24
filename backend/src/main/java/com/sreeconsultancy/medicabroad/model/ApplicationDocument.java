package com.sreeconsultancy.medicabroad.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One stored document belonging to an application. We keep only the metadata +
 * a storage key here — the actual file bytes live in the storage backend
 * (local folder now, Cloudflare R2 later), NOT in the database.
 */
@Entity
@Table(name = "application_documents")
@Getter
@Setter
@NoArgsConstructor
public class ApplicationDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DocType docType;

    /** Locator returned by the StorageService (e.g. "appId/PASSPORT.pdf"). */
    @Column(nullable = false)
    private String storageKey;

    private String originalName;
    private String contentType;
    private long sizeBytes;

    public ApplicationDocument(DocType docType, String storageKey,
                               String originalName, String contentType, long sizeBytes) {
        this.docType = docType;
        this.storageKey = storageKey;
        this.originalName = originalName;
        this.contentType = contentType;
        this.sizeBytes = sizeBytes;
    }
}
