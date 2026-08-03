package com.sreeconsultancy.medicabroad.model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OrderColumn;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * A university / college offering. This is the single source of truth that
 * both the student site (read-only) and the admin panel (read/write) use.
 */
@Entity
@Table(name = "colleges")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class College {

    /** Human-readable stable id, e.g. "ge-01". */
    @Id
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String country;

    @Column(nullable = false)
    private String program;

    @Column(nullable = false)
    private String level;

    @Column(nullable = false)
    private String intake;

    /** false => "Admission Closed" (shown but not selectable on the site). */
    @Column(nullable = false)
    private boolean admissionOpen;

    /** Long-form copy for the college's public detail page. Nullable — the
     * site renders a generated fallback sentence when this is empty. */
    @Column(columnDefinition = "TEXT")
    private String description;

    /** Approximate tuition, USD/year. Nullable until an admin fills it in. */
    private Integer feesPerYearUsd;

    /** Programme length in years. Nullable until an admin fills it in. */
    private Integer durationYears;

    /** Short "why this college" bullets, shown in order on the detail page.
     * Eager — this is a 0-4 item list, and repository.findAll() is called
     * outside a transaction (open-in-view is off), so lazy would throw. */
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "college_highlights", joinColumns = @JoinColumn(name = "college_id"))
    @OrderColumn(name = "position")
    @Column(name = "highlight", columnDefinition = "TEXT")
    private List<String> highlights = new ArrayList<>();
}
