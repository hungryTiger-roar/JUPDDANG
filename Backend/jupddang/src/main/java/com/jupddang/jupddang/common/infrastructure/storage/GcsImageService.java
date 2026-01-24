package com.jupddang.jupddang.common.infrastructure.storage;

import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.jupddang.jupddang.common.exception.ImageUploadException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class GcsImageService {

    private final Storage storage;

    @Value("${spring.cloud.gcp.storage.bucket}")
    private String bucketName;

    // 허용 파일 형식
    private static final List<String> ALLOWED_TYPES = Arrays.asList(
            "image/jpeg", "image/jpg", "image/png"
    );

    // 최대 파일 크기 (5MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    /**
     * 이미지를 GCS에 업로드 (유효성 검증 추가)
     */
    public String uploadImage(MultipartFile file, String folder) {
        try {
            // 1. 유효성 검증
            validateImage(file);

            // 2. 파일명 생성
            String fileName = generateFileName(file.getOriginalFilename());
            String objectName = folder + "/" + fileName;

            log.info("GCS 업로드 시작: {}", objectName);

            // 3. BlobId 생성
            BlobId blobId = BlobId.of(bucketName, objectName);

            // 4. BlobInfo 생성
            BlobInfo blobInfo = BlobInfo.newBuilder(blobId)
                    .setContentType(file.getContentType())
                    .build();

            // 5. GCS에 업로드
            storage.create(blobInfo, file.getBytes());

            // 6. URL 생성
            String imageUrl = "https://storage.googleapis.com/" +
                    bucketName + "/" + objectName;

            log.info("GCS 업로드 완료: {}", imageUrl);

            return imageUrl;

        } catch (IOException e) {
            log.error("GCS 업로드 실패", e);
            throw new ImageUploadException("이미지 업로드에 실패했습니다", e);
        }
    }

    /**
     * 이미지 유효성 검증
     */
    private void validateImage(MultipartFile file) {
        // 1. 파일 존재 확인
        if (file == null || file.isEmpty()) {
            throw new ImageUploadException("파일이 비어있습니다");
        }

        // 2. 파일 크기 확인
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new ImageUploadException(
                    String.format("파일 크기는 %dMB 이하여야 합니다",
                            MAX_FILE_SIZE / 1024 / 1024)
            );
        }

        // 3. 파일 형식 확인
        String contentType = file.getContentType();
        if (!ALLOWED_TYPES.contains(contentType)) {
            throw new ImageUploadException(
                    "jpg, png 이미지만 업로드 가능합니다"
            );
        }
    }

    /**
     * GCS에서 이미지 삭제
     */
    public void deleteImage(String imageUrl) {
        try {
            String objectName = extractObjectName(imageUrl);

            log.info("GCS 삭제 시작: {}", objectName);

            BlobId blobId = BlobId.of(bucketName, objectName);
            boolean deleted = storage.delete(blobId);

            if (deleted) {
                log.info("GCS 삭제 완료: {}", objectName);
            } else {
                log.warn("GCS 삭제 실패 (파일 없음): {}", objectName);
            }

        } catch (Exception e) {
            log.error("GCS 삭제 중 에러", e);
        }
    }

    private String generateFileName(String originalFilename) {
        String extension = getFileExtension(originalFilename);
        return UUID.randomUUID().toString() +
                "_" + System.currentTimeMillis() +
                "." + extension;
    }

    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "jpg";
        }
        return filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
    }

    private String extractObjectName(String imageUrl) {
        String prefix = "https://storage.googleapis.com/" + bucketName + "/";
        if (imageUrl.startsWith(prefix)) {
            return imageUrl.substring(prefix.length());
        }
        throw new IllegalArgumentException("잘못된 이미지 URL: " + imageUrl);
    }
}