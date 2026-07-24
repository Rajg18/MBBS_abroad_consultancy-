package com.sreeconsultancy.medicabroad.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
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
}
