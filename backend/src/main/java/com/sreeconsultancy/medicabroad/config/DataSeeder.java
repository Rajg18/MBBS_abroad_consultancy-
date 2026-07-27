package com.sreeconsultancy.medicabroad.config;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.sreeconsultancy.medicabroad.model.College;
import com.sreeconsultancy.medicabroad.repository.CollegeRepository;

/**
 * Seeds the 100-college catalogue on first startup (only if the table is empty).
 * Mirrors the frontend seed list. The 23 unclear Russia names are intentionally
 * omitted — the client adds those later via the admin panel.
 */
@Component
public class DataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    private final CollegeRepository repository;

    public DataSeeder(CollegeRepository repository) {
        this.repository = repository;
    }

    @Override
    public void run(String... args) {
        if (repository.count() > 0) {
            log.info("Colleges already present ({}). Skipping seed.", repository.count());
            return;
        }
        List<College> colleges = buildSeed();
        repository.saveAll(colleges);
        log.info("Seeded {} colleges into the database.", colleges.size());
    }

    // General Medicine · Bachelor · Sep-26 · admission open
    private static College gm(String id, String name, String country) {
        return new College(id, name, country, "General Medicine", "Bachelor", "Sep-26", true);
    }

    // Integrated American Program variant (open)
    private static College iap(String id, String name, String country) {
        return new College(id, name, country, "Integrated American Program", "Bachelor", "Sep-26", true);
    }

    // General Medicine · Bachelor · Sep-26 · admission CLOSED
    private static College closed(String id, String name, String country) {
        return new College(id, name, country, "General Medicine", "Bachelor", "Sep-26", false);
    }

    private List<College> buildSeed() {
        List<College> c = new ArrayList<>();

        // ── Georgia (22) ──
        c.add(gm("ge-01", "Alte University", "Georgia"));
        c.add(gm("ge-02", "Grigol Robakidze University", "Georgia"));
        c.add(gm("ge-03", "Georgian National University SEU", "Georgia"));
        c.add(gm("ge-04", "University of Georgia", "Georgia"));
        c.add(gm("ge-05", "David Tvildiani Medical University", "Georgia"));
        c.add(gm("ge-06", "Caucasus University", "Georgia"));
        c.add(iap("ge-07", "Caucasus University", "Georgia"));
        c.add(gm("ge-08", "Tbilisi State Medical University", "Georgia"));
        c.add(iap("ge-09", "Tbilisi State Medical University", "Georgia"));
        c.add(gm("ge-10", "Ivane Javakhishvili Tbilisi State University", "Georgia"));
        c.add(gm("ge-11", "Avicenna Batumi Medical University", "Georgia"));
        c.add(gm("ge-12", "New Vision University", "Georgia"));
        c.add(gm("ge-13", "Batumi Shota Rustaveli State University", "Georgia"));
        c.add(gm("ge-14", "Ilia State University", "Georgia"));
        c.add(gm("ge-15", "Tbilisi Medical Academy", "Georgia"));
        c.add(gm("ge-16", "East European University Faculty of Healthcare Sciences", "Georgia"));
        c.add(gm("ge-17", "Teaching University Geomedi", "Georgia"));
        c.add(gm("ge-18", "East-West University", "Georgia"));
        c.add(gm("ge-19", "Caucasus International University", "Georgia"));
        c.add(gm("ge-20", "European University", "Georgia"));
        c.add(gm("ge-21", "Akaki Tsereteli State University", "Georgia"));
        c.add(gm("ge-22", "Kutaisi University Faculty of Medicine", "Georgia"));

        // ── China (20) ──
        c.add(gm("cn-01", "Xuzhou Medical University", "China"));
        c.add(gm("cn-02", "Zhengzhou University", "China"));
        c.add(gm("cn-03", "Southern Medical University", "China"));
        c.add(gm("cn-04", "Nantong University", "China"));
        c.add(gm("cn-05", "Tongji Medical University", "China"));
        c.add(gm("cn-06", "Beihua Medical University", "China"));
        c.add(gm("cn-07", "Hebei Medical University", "China"));
        c.add(gm("cn-08", "Yangzhou University", "China"));
        c.add(gm("cn-09", "Qiqihar Medical University", "China"));
        c.add(gm("cn-10", "Xinxiang Medical University", "China"));
        c.add(gm("cn-11", "Anhui Medical University", "China"));
        c.add(gm("cn-12", "Xinjiang Medical University", "China"));
        c.add(gm("cn-13", "Guangxi Medical University", "China"));
        c.add(gm("cn-14", "Guangzhou Medical University", "China"));
        c.add(gm("cn-15", "Harbin Medical University", "China"));
        c.add(gm("cn-16", "Ningxia Medical University", "China"));
        c.add(gm("cn-17", "North Sichuan Medical College", "China"));
        c.add(gm("cn-18", "Shihezi Medical University", "China"));
        c.add(gm("cn-19", "Sichuan University", "China"));
        c.add(gm("cn-20", "Southeast University", "China"));

        // ── Philippines (12) ──
        c.add(gm("ph-01", "University of Perpetual Help", "Philippines"));
        c.add(gm("ph-02", "Emilio Aguinaldo College", "Philippines"));
        c.add(gm("ph-03", "UV Gullas College of Medicine", "Philippines"));
        c.add(gm("ph-04", "Our Lady of Fatima University (OLFU)", "Philippines"));
        c.add(gm("ph-05", "University of Perpetual Help Dr. Jose G. Tamayo Medical University", "Philippines"));
        c.add(gm("ph-06", "University of Northern Philippines", "Philippines"));
        c.add(gm("ph-07", "St Paul University", "Philippines"));
        c.add(gm("ph-08", "St Dominic University", "Philippines"));
        c.add(gm("ph-09", "Bulacan State University", "Philippines"));
        c.add(gm("ph-10", "Cavite State University", "Philippines"));
        c.add(gm("ph-11", "South Luzon State University", "Philippines"));
        c.add(gm("ph-12", "Davao Medical University", "Philippines"));

        // ── Malaysia (3) ──
        c.add(gm("my-01", "Mahsa University", "Malaysia"));
        c.add(gm("my-02", "SEGi University & Colleges", "Malaysia"));
        c.add(gm("my-03", "Manipal University College", "Malaysia"));

        // ── Germany (1) — Medical PG · Master · CLOSED ──
        c.add(new College("de-01", "FHM University", "Germany", "Medical PG", "Master", "Sep-26", false));

        // ── USA via Caribbean (1) — CLOSED ──
        c.add(closed("us-01", "St. George's University (SGU)", "USA via Caribbean"));

        // ── Russia (41) ──
        c.add(gm("ru-01", "Pskov State University", "Russia"));
        c.add(gm("ru-02", "Ryazan State Medical University", "Russia"));
        c.add(gm("ru-03", "Siberian State Medical University", "Russia"));
        c.add(gm("ru-04", "Novosibirsk State University", "Russia"));
        c.add(gm("ru-05", "South Ural State Medical University", "Russia"));
        c.add(gm("ru-06", "Tambov State University", "Russia"));
        c.add(gm("ru-07", "Tyumen State Medical University", "Russia"));
        c.add(gm("ru-08", "Ulyanovsk State University", "Russia"));
        c.add(gm("ru-09", "North-Caucasus Federal University", "Russia"));
        c.add(gm("ru-10", "Sevastopol State University", "Russia"));
        c.add(gm("ru-11", "Northern State Medical University", "Russia"));
        c.add(gm("ru-12", "Rostov State Medical University", "Russia"));
        c.add(gm("ru-13", "Kursk State Medical University", "Russia"));
        c.add(gm("ru-14", "Kazan State Medical University", "Russia"));
        c.add(gm("ru-15", "Kazan Federal University", "Russia"));
        c.add(gm("ru-16", "Chechen State University", "Russia"));
        c.add(gm("ru-17", "Far Eastern Federal University", "Russia"));
        c.add(gm("ru-18", "Volgograd State Medical University", "Russia"));
        c.add(gm("ru-19", "Crimean Federal University", "Russia"));
        c.add(gm("ru-20", "Samara Medical Institute", "Russia"));
        c.add(gm("ru-21", "Altai State Medical University", "Russia"));
        c.add(gm("ru-22", "Bashkir State Medical University", "Russia"));
        c.add(gm("ru-23", "Smolensk State Medical University", "Russia"));
        c.add(gm("ru-24", "Astrakhan State University", "Russia"));
        c.add(gm("ru-25", "Mordovia State University", "Russia"));
        c.add(gm("ru-26", "Tula State University", "Russia"));
        c.add(gm("ru-27", "Yaroslavl State University", "Russia"));
        c.add(gm("ru-28", "Omsk State University", "Russia"));
        c.add(closed("ru-29", "Pacific State Medical University", "Russia"));
        c.add(closed("ru-30", "Chita State Medical Academy", "Russia"));
        c.add(gm("ru-31", "Kemerovo State Medical University", "Russia"));
        c.add(gm("ru-32", "Dagestan State Medical University", "Russia"));
        c.add(gm("ru-33", "Mari State University", "Russia"));
        c.add(gm("ru-34", "Orenburg State Medical University", "Russia"));
        c.add(gm("ru-35", "Perm State Medical University", "Russia"));
        c.add(gm("ru-36", "Voronezh State Medical University", "Russia"));
        c.add(gm("ru-37", "Kuban State Medical University", "Russia"));
        c.add(gm("ru-38", "Saratov State Medical University", "Russia"));
        c.add(gm("ru-39", "Ural State Medical University", "Russia"));
        c.add(gm("ru-40", "Penza State University", "Russia"));
        c.add(gm("ru-41", "Tver State Medical University", "Russia"));

        // ── Italy (17) ──
        c.add(gm("it-01", "University of Bari Aldo Moro", "Italy"));
        c.add(gm("it-02", "University of Bologna", "Italy"));
        c.add(gm("it-03", "University of Catania", "Italy"));
        c.add(gm("it-04", "University of Messina", "Italy"));
        c.add(gm("it-05", "University of Naples Federico II", "Italy"));
        c.add(gm("it-06", "University of Parma", "Italy"));
        c.add(gm("it-07", "University of Pavia", "Italy"));
        c.add(gm("it-08", "University of Turin", "Italy"));
        c.add(gm("it-09", "Sapienza University of Rome", "Italy"));
        c.add(gm("it-10", "Vita-Salute San Raffaele University", "Italy"));
        c.add(gm("it-11", "University of Milano-Bicocca", "Italy"));
        c.add(gm("it-12", "University of Campania Luigi Vanvitelli", "Italy"));
        c.add(gm("it-13", "Catholic University of the Sacred Heart", "Italy"));
        c.add(gm("it-14", "Humanitas University - Hunimed", "Italy"));
        c.add(gm("it-15", "Campus Bio-Medico University of Rome", "Italy"));
        c.add(gm("it-16", "International Medical School (IMS), University of Milan", "Italy"));
        c.add(gm("it-17", "Saint Camillus International University of Health Sciences (UniCamillus)", "Italy"));

        return c;
    }
}
