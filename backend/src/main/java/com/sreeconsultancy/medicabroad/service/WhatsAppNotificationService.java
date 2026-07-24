package com.sreeconsultancy.medicabroad.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import com.sreeconsultancy.medicabroad.config.WhatsAppProperties;

/**
 * Sends the admin a WhatsApp "new application" template message.
 *
 * Runs on a background thread ({@link Async}) so a slow/failing WhatsApp call
 * never affects the student's submission. Retries a few times, and swallows
 * all errors (they are logged, never rethrown).
 */
@Service
public class WhatsAppNotificationService implements NotificationService {

    private static final Logger log = LoggerFactory.getLogger(WhatsAppNotificationService.class);
    private static final int MAX_ATTEMPTS = 3;

    private final WhatsAppProperties props;
    private final RestClient restClient = RestClient.create();

    public WhatsAppNotificationService(WhatsAppProperties props) {
        this.props = props;
    }

    @Async
    @Override
    public void notifyNewApplication(NotificationPayload p) {
        if (!props.isConfigured()) {
            // Fallback while WhatsApp is off / template pending: just log it.
            log.info("[WhatsApp disabled] New application {} | {} | {} | {} | countries={} | colleges={}",
                    p.applicationId(), p.fullName(), p.phone(), p.email(),
                    p.countries(), p.collegeNames());
            return;
        }

        String url = String.format("https://graph.facebook.com/%s/%s/messages",
                props.getApiVersion(), props.getPhoneNumberId());
        Map<String, Object> body = buildTemplateBody(p);

        for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
            try {
                restClient.post()
                        .uri(url)
                        .header("Authorization", "Bearer " + props.getToken())
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(body)
                        .retrieve()
                        .toBodilessEntity();
                log.info("WhatsApp notification sent for application {}", p.applicationId());
                return;
            } catch (Exception e) {
                log.warn("WhatsApp send attempt {}/{} failed for application {}: {}",
                        attempt, MAX_ATTEMPTS, p.applicationId(), e.getMessage());
                if (attempt < MAX_ATTEMPTS) {
                    try {
                        Thread.sleep(1000L * attempt); // simple backoff
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        return;
                    }
                }
            }
        }
        log.error("WhatsApp notification FAILED after {} attempts for application {}",
                MAX_ATTEMPTS, p.applicationId());
    }

    private Map<String, Object> buildTemplateBody(NotificationPayload p) {
        // Named parameters — the template uses {{name}}, {{phone}}, {{email}},
        // {{countries}}, {{colleges}} (named variables, not numbered {{1}}..{{5}}).
        List<Map<String, String>> parameters = List.of(
                namedParam("name", p.fullName()),
                namedParam("phone", p.phone()),
                namedParam("email", p.email()),
                namedParam("countries", String.join(", ", p.countries())),
                namedParam("colleges", String.join(", ", p.collegeNames()))
        );
        Map<String, Object> bodyComponent = Map.of(
                "type", "body",
                "parameters", parameters);
        Map<String, Object> template = Map.of(
                "name", props.getTemplateName(),
                "language", Map.of("code", props.getLanguageCode()),
                "components", List.of(bodyComponent));
        return Map.of(
                "messaging_product", "whatsapp",
                "to", props.getAdminTo(),
                "type", "template",
                "template", template);
    }

    private static Map<String, String> namedParam(String name, String value) {
        String safe = (value == null || value.isBlank()) ? "-" : value;
        return Map.of("type", "text", "parameter_name", name, "text", safe);
    }
}
