package com.jupddang.jupddang.common.infrastructure.storage;

import com.google.cloud.storage.*;
import com.sksamuel.scrimage.ImmutableImage;
import com.sksamuel.scrimage.webp.WebpWriter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class GcsImageService {

    private final Storage storage;

    @Value("${gcs.bucket.name}")
    private String bucketName;

    // 이미지 최적화 설정
    private static final int MAX_SIZE = 1920;
    private static final int WEBP_QUALITY = 90;  // 0-100
    private static final String IMAGE_FORMAT = "webp";
    private static final String CONTENT_TYPE = "image/webp";

    /**
     * 이미지 업로드 (WebP 최적화 적용)
     */
    public String uploadImage(MultipartFile file, String folder) {
        try {
            log.info("이미지 업로드 시작 - 원본 크기: {}KB", file.getSize() / 1024);

            // 1. 이미지 최적화 (WebP 변환)
            byte[] optimizedImageBytes = optimizeImageToWebP(file);

            log.info("이미지 최적화 완료 - 변환 후 크기: {}KB", optimizedImageBytes.length / 1024);

            // 2. 파일명 생성
            String originalFileName = file.getOriginalFilename();
            String baseFileName = originalFileName != null ?
                    originalFileName.substring(0, originalFileName.lastIndexOf('.')) :
                    UUID.randomUUID().toString();
            String fileName = folder + "/" + UUID.randomUUID() + "_" + baseFileName + "." + IMAGE_FORMAT;

            // 3. GCS에 업로드
            BlobId blobId = BlobId.of(bucketName, fileName);
            BlobInfo blobInfo = BlobInfo.newBuilder(blobId)
                    .setContentType(CONTENT_TYPE)
                    .setCacheControl("public, max-age=31536000") // 1년 캐싱
                    .build();

            storage.create(blobInfo, optimizedImageBytes);

            // 4. 공개 URL 반환
            String imageUrl = String.format("https://storage.googleapis.com/%s/%s", bucketName, fileName);
            log.info("이미지 업로드 성공: {}", imageUrl);

            return imageUrl;

        } catch (Exception e) {
            log.error("이미지 업로드 실패: {}", e.getMessage(), e);
            throw new RuntimeException("이미지 업로드에 실패했습니다.", e);
        }
    }

    /**
     * WebP 형식으로 이미지 최적화 (Scrimage 사용)
     */
    private byte[] optimizeImageToWebP(MultipartFile file) throws IOException {
        // 원본 이미지 로드
        ImmutableImage originalImage = ImmutableImage.loader()
                .fromBytes(file.getBytes());

        log.info("원본 이미지 크기: {}x{}", originalImage.width, originalImage.height);

        // 이미지 리사이징 (비율 유지하면서 MAX_SIZE 이내로)
        ImmutableImage resizedImage;
        if (originalImage.width > MAX_SIZE || originalImage.height > MAX_SIZE) {
            resizedImage = originalImage.max(MAX_SIZE, MAX_SIZE);
            log.info("리사이징 완료: {}x{}", resizedImage.width, resizedImage.height);
        } else {
            resizedImage = originalImage;
            log.info("리사이징 불필요");
        }

        // WebP로 변환
        WebpWriter writer = WebpWriter.DEFAULT.withQ(WEBP_QUALITY);
        byte[] webpBytes = resizedImage.bytes(writer);

        return webpBytes;
    }

    /**
     * 이미지 삭제
     */
    public void deleteImage(String imageUrl) {
        if (imageUrl == null || imageUrl.isEmpty()) {
            log.warn("삭제할 이미지 URL이 없습니다.");
            return;
        }

        try {
            // URL에서 파일명 추출
            String fileName = imageUrl.substring(imageUrl.indexOf(bucketName) + bucketName.length() + 1);
            BlobId blobId = BlobId.of(bucketName, fileName);

            boolean deleted = storage.delete(blobId);

            if (deleted) {
                log.info("이미지 삭제 완료: {}", fileName);
            } else {
                log.warn("이미지를 찾을 수 없음: {}", fileName);
            }

        } catch (Exception e) {
            log.error("이미지 삭제 실패: {}", e.getMessage(), e);
        }
    }
}