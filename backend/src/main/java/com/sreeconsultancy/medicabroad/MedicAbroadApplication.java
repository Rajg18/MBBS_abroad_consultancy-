package com.sreeconsultancy.medicabroad;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

/// Entry point for the Sree Consultancy MBBS-abroad backend API.
@EnableAsync
@SpringBootApplication
public class MedicAbroadApplication {
    public static void main(String[] args) {
        SpringApplication.run(MedicAbroadApplication.class, args);
    }
}
