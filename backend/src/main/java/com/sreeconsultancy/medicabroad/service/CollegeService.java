package com.sreeconsultancy.medicabroad.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sreeconsultancy.medicabroad.dto.CollegeResponse;
import com.sreeconsultancy.medicabroad.dto.CountryResponse;
import com.sreeconsultancy.medicabroad.model.College;
import com.sreeconsultancy.medicabroad.repository.CollegeRepository;

/** Read operations over the college catalogue for the student site. */
@Service
public class CollegeService {

    /** Country display order + flag (kept here so the API owns presentation). */
    private static final Map<String, String> COUNTRY_FLAGS = new LinkedHashMap<>();
    static {
        COUNTRY_FLAGS.put("Georgia", "🇬🇪");
        COUNTRY_FLAGS.put("China", "🇨🇳");
        COUNTRY_FLAGS.put("Philippines", "🇵🇭");
        COUNTRY_FLAGS.put("Malaysia", "🇲🇾");
        COUNTRY_FLAGS.put("Germany", "🇩🇪");
        COUNTRY_FLAGS.put("USA via Caribbean", "🇺🇸");
        COUNTRY_FLAGS.put("Russia", "🇷🇺");
        COUNTRY_FLAGS.put("Italy", "🇮🇹");
        COUNTRY_FLAGS.put("Kazakhstan", "🇰🇿");
        COUNTRY_FLAGS.put("Uzbekistan", "🇺🇿");
        COUNTRY_FLAGS.put("Nepal", "🇳🇵");
    }

    private final CollegeRepository repository;

    public CollegeService(CollegeRepository repository) {
        this.repository = repository;
    }

    public List<CollegeResponse> getAllColleges() {
        return repository.findAllByOrderByIdAsc().stream()
                .map(CollegeResponse::from)
                .toList();
    }

    public List<CollegeResponse> getCollegesByCountry(String country) {
        return repository.findByCountryOrderByIdAsc(country).stream()
                .map(CollegeResponse::from)
                .toList();
    }

    /** Countries in display order, each with its flag and college counts. */
    public List<CountryResponse> getCountries() {
        List<College> all = repository.findAll();
        List<CountryResponse> result = new ArrayList<>();
        for (Map.Entry<String, String> entry : COUNTRY_FLAGS.entrySet()) {
            String country = entry.getKey();
            long total = all.stream().filter(c -> c.getCountry().equals(country)).count();
            long open = all.stream()
                    .filter(c -> c.getCountry().equals(country) && c.isAdmissionOpen())
                    .count();
            result.add(new CountryResponse(country, entry.getValue(), total, open));
        }
        return result;
    }
}
