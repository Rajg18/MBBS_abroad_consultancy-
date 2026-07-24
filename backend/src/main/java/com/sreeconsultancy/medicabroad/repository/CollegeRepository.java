package com.sreeconsultancy.medicabroad.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sreeconsultancy.medicabroad.model.College;

/** Database access for {@link College} records. */
public interface CollegeRepository extends JpaRepository<College, String> {

    List<College> findAllByOrderByIdAsc();

    List<College> findByCountryOrderByIdAsc(String country);
}
