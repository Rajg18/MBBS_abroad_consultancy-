package com.sreeconsultancy.medicabroad.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sreeconsultancy.medicabroad.dto.CollegeResponse;
import com.sreeconsultancy.medicabroad.dto.CountryResponse;
import com.sreeconsultancy.medicabroad.service.CollegeService;

/**
 * Public read endpoints for the catalogue.
 *   GET /api/countries                 -> countries + flags + counts
 *   GET /api/colleges                  -> all colleges
 *   GET /api/colleges?country=Georgia  -> colleges in one country
 */
@RestController
@RequestMapping("/api")
public class CollegeController {

    private final CollegeService service;

    public CollegeController(CollegeService service) {
        this.service = service;
    }

    @GetMapping("/countries")
    public List<CountryResponse> countries() {
        return service.getCountries();
    }

    @GetMapping("/colleges")
    public List<CollegeResponse> colleges(@RequestParam(required = false) String country) {
        if (country != null && !country.isBlank()) {
            return service.getCollegesByCountry(country);
        }
        return service.getAllColleges();
    }
}
