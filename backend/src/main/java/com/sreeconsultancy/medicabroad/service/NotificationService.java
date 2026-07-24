package com.sreeconsultancy.medicabroad.service;

/** Notifies the admin about a new application (WhatsApp today, email later). */
public interface NotificationService {
    void notifyNewApplication(NotificationPayload payload);
}
