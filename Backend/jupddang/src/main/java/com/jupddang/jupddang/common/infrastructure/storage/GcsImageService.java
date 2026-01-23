package com.jupddang.jupddang.common.infrastructure.storage;

import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class GcsImageService {

    private final Storage storage;

    @Value("${spring.cloud.gcp.storage.bucket}")
    private String bucketName;

    /**
     * 이미지를 GCS에 업로드
     * @param file 업로드할 파일
     * @param folder 저장할 폴더 (before, after, map)
     * @return 업로드된 이미지 URL
     */
    public String uploadImage(MultipartFile file, String folder) {
        try {
            // 1. 파일명 생성 (UUID + timestamp)
            String fileName = generateFileName(file.getOriginalFilename());
            String objectName = folder + "/" + fileName;

            log.info("GCS 업로드 시작: {}", objectName);

            // 2. BlobId 생성
            BlobId blobId = BlobId.of(bucketName, objectName);

            // 3. BlobInfo 생성 (메타데이터)
            BlobInfo blobInfo = BlobInfo.newBuilder(blobId)
                    .setContentType(file.getContentType())
                    .build();

            // 4. GCS에 업로드
            storage.create(blobInfo, file.getBytes());

            // 5. URL 생성
            String imageUrl = "https://storage.googleapis.com/" +
                    bucketName + "/" + objectName;

            log.info("GCS 업로드 완료: {}", imageUrl);

            return imageUrl;

        } catch (IOException e) {
            log.error("GCS 업로드 실패", e);
            throw new RuntimeException("이미지 업로드에 실패했습니다", e);
        }
    }

    /**
     * GCS에서 이미지 삭제
     * @param imageUrl 삭제할 이미지 URL
     */
    public void deleteImage(String imageUrl) {
        try {
            // URL에서 objectName 추출
            String objectName = extractObjectName(imageUrl);

            log.info("GCS 삭제 시작: {}", objectName);

            // BlobId 생성
            BlobId blobId = BlobId.of(bucketName, objectName);

            // GCS에서 삭제
            boolean deleted = storage.delete(blobId);

            if (deleted) {
                log.info("GCS 삭제 완료: {}", objectName);
            } else {
                log.warn("GCS 삭제 실패 (파일 없음): {}", objectName);
            }

        } catch (Exception e) {
            log.error("GCS 삭제 중 에러", e);
            // 삭제 실패는 심각한 에러가 아니므로 예외를 던지지 않음
        }
    }

    /**
     * 파일명 생성 (UUID + timestamp)
     */
    private String generateFileName(String originalFilename) {
        String extension = getFileExtension(originalFilename);
        return UUID.randomUUID().toString() +
                "_" + System.currentTimeMillis() +
                "." + extension;
    }

    /**
     * 파일 확장자 추출
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "jpg";
        }
        return filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
    }

    /**
     * URL에서 objectName 추출
     * https://storage.googleapis.com/jupddang-images/before/abc.jpg
     * → before/abc.jpg
     */
    private String extractObjectName(String imageUrl) {
        String prefix = "https://storage.googleapis.com/" + bucketName + "/";
        if (imageUrl.startsWith(prefix)) {
            return imageUrl.substring(prefix.length());
        }
        throw new IllegalArgumentException("잘못된 이미지 URL: " + imageUrl);
    }
}