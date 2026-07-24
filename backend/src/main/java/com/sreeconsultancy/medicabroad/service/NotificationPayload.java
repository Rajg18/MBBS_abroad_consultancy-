package com.sreeconsultancy.medicabroad.service;

import java.util.List;

/**
 * Self-contained data for a notification, resolved inside the DB transaction
 * so the async sender never touches lazy entity state on another thread.
 */
public record NotificationPayload(
        String applicationId,
        String fullName,
        String phone,
        String email,
        List<String> countries,
        List<String> collegeNames
) {
}
