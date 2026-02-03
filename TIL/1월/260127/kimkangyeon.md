# 김강연 Today I Learned

---

## 1월 27일

## 📌 오늘 한 일

### 파티 플로깅 완료 API 구현

**문제:**
- 파티 플로깅과 개인 플로깅이 분리되어 데이터 일관성 부족
- 파티 활동 완료 시 사진 업로드 기능 없음

**해결:**
- PloggingService.endPlogging() 재사용으로 코드 중복 제거
- Multipart 요청 처리 (JSON + 이미지 3장)
- PartyActivity에 Plogging 참조 추가로 데이터 통합

**핵심 코드:**
```java
// PartyService에서 PloggingService 재사용
PloggingResultResponse result = ploggingService.endPlogging(...);
activity.complete(plogging);
```

---

## 💡 배운 점
1. `@RequestPart`에는 `consumes` 속성이 없음 → String으로 받아 수동 파싱
2. Postman에서 Multipart 요청 시 체크박스 필수 체크
3. 코드 재사용으로 유지보수성 향상

---

## 🐛 트러블슈팅

### 1. Content-Type 에러
**문제:** `Content-Type 'application/octet-stream' is not supported`

**원인:** `@RequestPart`에 `consumes` 속성 사용 불가

**해결:**
```java
// Before
@RequestPart(value = "data", consumes = "application/json") PloggingEndRequest request

// After
@RequestPart("data") String dataJson
PloggingEndRequest request = objectMapper.readValue(dataJson, PloggingEndRequest.class);
```

### 2. 변수 참조 오류
**문제:** `plogging`, `post` 변수를 찾을 수 없음

**원인:** 저장 결과를 변수에 할당하지 않음

**해결:**
```java
Plogging savedPlogging = ploggingRepository.save(...);
Post savedPost = postRepository.save(...);
```

### 3. GcsService 찾을 수 없음
**문제:** Import 경로 오류

**해결:**
```java
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
```