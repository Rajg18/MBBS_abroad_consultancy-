package com.sreeconsultancy.medicabroad.web;

/** Thrown for invalid submissions (bad file type, size, score, etc.). */
public class BadRequestException extends RuntimeException {
    public BadRequestException(String message) {
        super(message);
    }
}
