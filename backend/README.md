# Medic Abroad — Backend API

REST API for the Sree Consultancy MBBS-abroad application site.
Spring Boot 3.3.5 · Java 17 · PostgreSQL.

## Prerequisites
- Java 17
- Docker (for local PostgreSQL)

## Run locally

1. **Start PostgreSQL:**
   ```
   docker compose up -d
   ```
2. **Run the API:**
   ```
   ./mvnw.cmd spring-boot:run
   ```
3. **Verify:** open http://localhost:8080/api/health → `{"status":"UP", ...}`

## Configuration
Copy `.env.example` to `.env` and fill in values. Local dev works with the
defaults (they match `docker-compose.yml`). Secrets (WhatsApp token, R2 keys,
admin password hash) are added in later features and always come from the
environment — never hard-coded.

## Project layout
```
controller/   REST endpoints (the API "menu")
service/      business logic
repository/   database access (Spring Data JPA)
model/        JPA entities
dto/          request/response shapes
config/       app configuration
```

## Roadmap
- [x] Feature 1 — Foundation (scaffold, DB, health endpoint)
- [ ] Feature 2 — College catalog API + seed data
- [ ] Feature 3 — Application submission API + file storage
- [ ] Feature 4 — WhatsApp notification service
- [ ] Feature 5 — Admin auth
- [ ] Feature 6 — Admin API (applicants, downloads)
- [ ] Swap local storage → Cloudflare R2
