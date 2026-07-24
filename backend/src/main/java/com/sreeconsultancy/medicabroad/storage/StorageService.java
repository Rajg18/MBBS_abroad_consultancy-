package com.sreeconsultancy.medicabroad.storage;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

/**
 * Abstraction over document storage.
 *
 * A local-disk implementation is used for development; a Cloudflare R2
 * implementation will be swapped in for production with no change to callers.
 */
public interface StorageService {

    /**
     * Persist a file and return a storage key that uniquely locates it.
     *
     * @param file          the uploaded file
     * @param applicationId the owning application's id (used to group files)
     * @param docType       which document this is (e.g. "PASSPORT")
     * @return an opaque storage key (e.g. "abc123/PASSPORT.pdf")
     */
    String store(MultipartFile file, String applicationId, String docType);

    /**
     * Load a previously stored file for download.
     *
     * @param key the storage key returned by {@link #store}
     * @return a readable Spring Resource for streaming to the client
     */
    Resource loadAsResource(String key);
}
