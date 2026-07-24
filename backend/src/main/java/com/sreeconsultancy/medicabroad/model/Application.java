package com.sreeconsultancy.medicabroad.model;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderColumn;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** A submitted student application (details + preferences + documents). */
@Entity
@Table(name = "applications")
@Getter
@Setter
@NoArgsConstructor
public class Application {

    /** Assigned in the service before files are stored (used in storage keys). */
    @Id
    private String id;

    @Column(nullable = false)
    private String fullName;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false)
    private String email;

    /** Kept as typed text (int or float) exactly as the student entered it. */
    @Column(nullable = false)
    private String neetScore;

    @Column(nullable = false)
    private boolean consent;

    @Column(nullable = false)
    private String status;

    @Column(nullable = false)
    private Instant createdAt;

    /** Preferred countries in priority order (index 0 = 1st choice). */
    @ElementCollection
    @CollectionTable(name = "application_countries",
            joinColumns = @JoinColumn(name = "application_id"))
    @OrderColumn(name = "priority")
    @Column(name = "country")
    private List<String> preferredCountries = new ArrayList<>();

    /** Preferred college ids in priority order. */
    @ElementCollection
    @CollectionTable(name = "application_colleges",
            joinColumns = @JoinColumn(name = "application_id"))
    @OrderColumn(name = "priority")
    @Column(name = "college_id")
    private List<String> preferredCollegeIds = new ArrayList<>();

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "application_id")
    private List<ApplicationDocument> documents = new ArrayList<>();

    @PrePersist
    void onCreate() {
        if (createdAt == null) createdAt = Instant.now();
        if (status == null) status = "NEW";
    }
}
