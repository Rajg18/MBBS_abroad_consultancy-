package com.sreeconsultancy.medicabroad.storage;

import java.io.IOException;
import java.net.URI;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.NoSuchKeyException;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;

/**
 * Production storage: writes files to a Cloudflare R2 bucket via its
 * S3-compatible API.
 *
 * Active only when {@code app.storage.type=r2} (see application.yml). The
 * dev default remains {@link LocalStorageService}, so nothing changes for
 * local development unless this is explicitly enabled.
 *
 * Files are grouped per application, same key layout as local storage:
 * {applicationId}/{docType}.{ext}
 */
@Service
@ConditionalOnProperty(name = "app.storage.type", havingValue = "r2")
public class R2StorageService implements StorageService {

    private final S3Client s3;
    private final String bucket;

    public R2StorageService(
            @Value("${app.storage.r2.account-id}") String accountId,
            @Value("${app.storage.r2.access-key-id}") String accessKeyId,
            @Value("${app.storage.r2.secret-access-key}") String secretAccessKey,
            @Value("${app.storage.r2.bucket}") String bucket) {

        this.bucket = bucket;

        // R2's S3-compatible endpoint is account-scoped. Region is a required
        // SDK field but is not meaningful for R2 — "auto" is the convention.
        String endpoint = "https://" + accountId + ".r2.cloudflarestorage.com";

        this.s3 = S3Client.builder()
                .endpointOverride(URI.create(endpoint))
                .region(Region.of("auto"))
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(accessKeyId, secretAccessKey)))
                .build();
    }

    @Override
    public String store(MultipartFile file, String applicationId, String docType) {
        String ext = extensionOf(file.getOriginalFilename());
        String key = applicationId + "/" + docType + (ext.isEmpty() ? "" : "." + ext);

        try {
            PutObjectRequest request = PutObjectRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .contentType(file.getContentType())
                    .build();

            s3.putObject(request, RequestBody.fromInputStream(
                    file.getInputStream(), file.getSize()));

            return key;
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload file for " + docType, e);
        } catch (S3Exception e) {
            throw new RuntimeException("R2 upload failed for " + docType + ": " + e.getMessage(), e);
        }
    }

    @Override
    public Resource loadAsResource(String key) {
        try {
            GetObjectRequest request = GetObjectRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .build();

            ResponseInputStream<GetObjectResponse> response = s3.getObject(request);
            byte[] bytes = response.readAllBytes();
            return new ByteArrayResource(bytes) {
                @Override
                public String getFilename() {
                    // R2/S3 keys look like "appId/PASSPORT.pdf" — return just the file part.
                    int slash = key.lastIndexOf('/');
                    return slash == -1 ? key : key.substring(slash + 1);
                }
            };
        } catch (NoSuchKeyException e) {
            throw new IllegalStateException("File not found: " + key, e);
        } catch (IOException e) {
            throw new RuntimeException("Could not read file: " + key, e);
        }
    }

    private static String extensionOf(String filename) {
        if (filename == null) return "";
        int dot = filename.lastIndexOf('.');
        return dot == -1 ? "" : filename.substring(dot + 1).toLowerCase();
    }
}
