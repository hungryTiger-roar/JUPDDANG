package com.jupddang.jupddang.plogging.service.impls;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.plogging.dto.response.TrashBoundingBox;
import com.jupddang.jupddang.plogging.dto.response.TrashDetectionResponse;
import com.jupddang.jupddang.plogging.service.TrashDetectionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;
import java.util.List;

/**
 * 쓰레기 탐지 서비스 구현체
 * Gemini API를 호출하여 이미지에서 쓰레기를 탐지합니다.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class TrashDetectionServiceImpl implements TrashDetectionService {

    private final ObjectMapper objectMapper;
    private final RestTemplate restTemplate;

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.url}")
    private String apiUrl;

    private static final int RESIZE_WIDTH = 300;
    private static final int RESIZE_HEIGHT = 300;

    @Override
    public TrashDetectionResponse detectTrash(MultipartFile image) {
        try {
            log.info("쓰레기 탐지 시작 - 원본 크기: {}KB", image.getSize() / 1024);

            // 1. 이미지를 Base64로 인코딩 (300x300 리사이즈)
            String base64Image = encodeImageToBase64(image);
            log.info("이미지 인코딩 완료");

            // 2. Gemini API 호출
            List<TrashBoundingBox> detections = callGeminiApi(base64Image);
            log.info("Gemini API 응답 수신 - 탐지된 객체: {}개", detections.size());

            return new TrashDetectionResponse(
                    true,
                    "탐지 완료: " + detections.size() + "개의 쓰레기 발견",
                    detections);

        } catch (Exception e) {
            log.error("쓰레기 탐지 실패: {}", e.getMessage(), e);
            return new TrashDetectionResponse(
                    false,
                    "탐지 실패: " + e.getMessage(),
                    Collections.emptyList());
        }
    }

    /**
     * 이미지를 300x300으로 리사이즈 후 Base64 인코딩
     */
    private String encodeImageToBase64(MultipartFile file) throws IOException {
        BufferedImage originalImage = ImageIO.read(file.getInputStream());

        if (originalImage == null) {
            throw new IOException("이미지를 읽을 수 없습니다. 지원되지 않는 형식일 수 있습니다.");
        }

        // 리사이즈
        BufferedImage resizedImage = new BufferedImage(RESIZE_WIDTH, RESIZE_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = resizedImage.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g.drawImage(originalImage, 0, 0, RESIZE_WIDTH, RESIZE_HEIGHT, null);
        g.dispose();

        // JPEG로 압축 후 Base64 인코딩
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(resizedImage, "jpg", baos);

        return Base64.getEncoder().encodeToString(baos.toByteArray());
    }

    /**
     * Gemini API 호출하여 쓰레기 탐지
     */
    private List<TrashBoundingBox> callGeminiApi(String base64Image) throws Exception {
        // 프롬프트 (Python 코드와 동일)
        String promptText = """
                Detect all trash bags or piles of waste in this image.
                Return ONLY a JSON array of bounding boxes. Do not include markdown formatting.
                Format example: [{"box_2d": [ymin, xmin, ymax, xmax], "label": "trash"}]
                Coordinates must be normalized to 0-1000 scale.
                """;

        // 요청 본문 구성
        Map<String, Object> payload = buildRequestPayload(promptText, base64Image);

        // HTTP 요청
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("x-goog-api-key", apiKey);

        HttpEntity<String> request = new HttpEntity<>(
                objectMapper.writeValueAsString(payload),
                headers);

        log.debug("Gemini API 요청 전송: {}", apiUrl);
        ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, request, String.class);

        if (!response.getStatusCode().is2xxSuccessful()) {
            throw new RuntimeException("Gemini API 호출 실패: " + response.getStatusCode());
        }

        // 응답 파싱
        return parseGeminiResponse(response.getBody());
    }

    /**
     * Gemini API 요청 Payload 구성
     */
    private Map<String, Object> buildRequestPayload(String promptText, String base64Image) {
        Map<String, Object> payload = new HashMap<>();

        // contents
        List<Map<String, Object>> parts = new ArrayList<>();
        parts.add(Map.of("text", promptText));
        parts.add(Map.of("inline_data", Map.of(
                "mime_type", "image/jpeg",
                "data", base64Image)));

        payload.put("contents", List.of(Map.of("parts", parts)));

        // generationConfig
        payload.put("generationConfig", Map.of(
                "temperature", 0.1,
                "maxOutputTokens", 4096,
                "responseMimeType", "application/json"));

        return payload;
    }

    /**
     * Gemini API 응답 파싱
     */
    @SuppressWarnings("unchecked")
    private List<TrashBoundingBox> parseGeminiResponse(String responseBody) throws Exception {
        JsonNode root = objectMapper.readTree(responseBody);

        // candidates[0].content.parts[0].text 추출
        JsonNode candidates = root.path("candidates");
        if (candidates.isEmpty() || !candidates.isArray()) {
            log.warn("Gemini 응답에 candidates가 없습니다: {}", responseBody);
            return Collections.emptyList();
        }

        String textResult = candidates.get(0)
                .path("content")
                .path("parts").get(0)
                .path("text").asText();

        log.debug("Gemini 응답 텍스트: {}", textResult);

        // 빈 응답 처리
        if (textResult == null || textResult.isBlank() || textResult.equals("[]")) {
            return Collections.emptyList();
        }

        // JSON 배열 파싱
        List<Map<String, Object>> rawList = objectMapper.readValue(
                textResult,
                new TypeReference<List<Map<String, Object>>>() {
                });

        return rawList.stream()
                .map(item -> {
                    Object boxObj = item.get("box_2d");
                    List<Integer> box = null;

                    if (boxObj instanceof List<?>) {
                        box = ((List<?>) boxObj).stream()
                                .map(v -> ((Number) v).intValue())
                                .toList();
                    }

                    return new TrashBoundingBox(
                            box,
                            (String) item.getOrDefault("label", "trash"));
                })
                .toList();
    }
}
