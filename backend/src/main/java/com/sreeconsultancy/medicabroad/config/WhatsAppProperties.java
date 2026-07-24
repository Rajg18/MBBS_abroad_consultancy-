package com.sreeconsultancy.medicabroad.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.Setter;

/**
 * WhatsApp Cloud API settings (bound from `whatsapp.*` / environment).
 *
 * Secrets (token) come from the environment and are never committed.
 * While {@code enabled} is false (default), notifications are logged instead
 * of sent — useful in dev and until the Meta template is approved.
 */
@Component
@ConfigurationProperties(prefix = "whatsapp")
@Getter
@Setter
public class WhatsAppProperties {
    private boolean enabled = false;
    private String apiVersion = "v22.0";
    private String phoneNumberId = "";
    private String token = "";
    private String templateName = "new_application";
    private String languageCode = "en";
    private String adminTo = "";

    public boolean isConfigured() {
        return enabled
                && !token.isBlank()
                && !phoneNumberId.isBlank()
                && !adminTo.isBlank();
    }
}
