package com.sreeconsultancy.medicabroad.storage;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * Development storage: writes files to a local folder.
 *
 * Files are grouped per application: {baseDir}/{applicationId}/{docType}.{ext}
 * Active by default (app.storage.type=local); set app.storage.type=r2 to use
 * {@link R2StorageService} (Cloudflare R2) instead, e.g. in production.
 */
@Service
@ConditionalOnProperty(name = "app.storage.type", havingValue = "local", matchIfMissing = true)
public class LocalStorageService implements StorageService {

    private final Path baseDir;

    public LocalStorageService(@Value("${app.storage.local-dir:uploads}") String dir) {
        this.baseDir = Paths.get(dir).toAbsolutePath().normalize();
    }

    @Override
    public String store(MultipartFile file, String applicationId, String docType) {
        String ext = extensionOf(file.getOriginalFilename());
        String key = applicationId + "/" + docType + (ext.isEmpty() ? "" : "." + ext);
        try {
            Path target = baseDir.resolve(key).normalize();
            // Guard against path traversal escaping the base directory.
            if (!target.startsWith(baseDir)) {
                throw new IllegalArgumentException("Invalid storage path");
            }
            Files.createDirectories(target.getParent());
            try (var in = file.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
            return key;
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file for " + docType, e);
        }
    }

    @Override
    public Resource loadAsResource(String key) {
        try {
            Path target = baseDir.resolve(key).normalize();
            if (!target.startsWith(baseDir)) {
                throw new IllegalArgumentException("Invalid storage path");
            }
            Resource resource = new UrlResource(target.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                throw new IllegalStateException("File not found: " + key);
            }
            return resource;
        } catch (java.net.MalformedURLException e) {
            throw new RuntimeException("Could not read file: " + key, e);
        }
    }

    private static String extensionOf(String filename) {
        if (filename == null) return "";
        int dot = filename.lastIndexOf('.');
        return dot == -1 ? "" : filename.substring(dot + 1).toLowerCase();
    }
}
