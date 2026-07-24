package com.sreeconsultancy.medicabroad.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sreeconsultancy.medicabroad.model.Application;

/** Database access for {@link Application} records. */
public interface ApplicationRepository extends JpaRepository<Application, String> {

    List<Application> findAllByOrderByCreatedAtDesc();
}
