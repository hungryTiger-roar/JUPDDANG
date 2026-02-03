# Today I Learned

**Date:** 2026. 01. 29

## 1. API 컨트랙트 불일치와 직렬화 전략: JacksonConfig의 도입

플로깅 종료 요청(`PloggingEndRequest`)을 처리하는 과정에서 JSON 파싱 에러가 발생했다. 단순한 오타 문제가 아니라, 클라이언트와 서버 간의 **데이터 타입 정의(Semantics)**와 **직렬화 전략**의 부재가 원인이었다.

### 📌 DTO 필드 불일치와 타입의 모호성

* **문제 상황:**
1. **필드 불일치:** 클라이언트는 `startTime`, `endTime`, `path`를 보냈으나, 서버 DTO는 `ploggingId`, `content`, `distance` 등을 요구함.
2. **의미론적 충돌:** 서버의 `endTime`은 '경과 시간(초, Integer)'을 의미했으나, 클라이언트는 '종료 시각(Timestamp, String)'으로 이해하고 데이터를 전송함. 여기에 잘못 붙은 `@JsonFormat` 어노테이션이 혼란을 가중시켰다.


* **해결책:** **Global Jackson Configuration** 도입을 통한 표준화.
1. **전역 설정:** 개별 DTO에 `@JsonFormat`을 덕지덕지 붙이는 대신, `JacksonConfig`를 생성하여 `JavaTimeModule` 등록 및 `WRITE_DATES_AS_TIMESTAMPS = false` 설정을 전역으로 적용.
2. **DTO 정비:** `endTime`과 같이 시간인지, 시각인지 모호한 필드의 네이밍과 타입을 명확히 정의(Integer vs LocalDateTime)하고, 불필요한 어노테이션을 제거했다.


* **효과:** 모든 API에서 `LocalDateTime`이 ISO 8601 표준으로 자동 직렬화되도록 통일성을 확보하고, DTO 코드를 깔끔하게 유지할 수 있게 되었다.

---

## 2. 인프라 보안 관리: GCS 인증 실패와 JWT 서명

개발 로직에는 문제가 없었으나, Google Cloud Storage(GCS) 연동 과정에서 `400 Bad Request`와 함께 `Invalid JWT Signature` 에러가 발생했다. 이는 코드가 아닌 **환경(Environment)**의 문제였다.

### 📌 서비스 계정 키(Service Account Key)의 유효성

* **문제:** 로컬 혹은 서버에 배치된 JSON 키 파일이 손상되었거나, 만료된 키를 참조하고 있어 인증 토큰 생성에 실패함.
* **해결 전략:** 키 라이프사이클 관리 및 재발급.
1. **키 재생성:** GCP IAM 콘솔에서 `jupddang-storage-service` 계정의 새로운 JSON 키를 발급.
2. **환경 재구성:** 서버 내 키 파일을 교체하고, `chmod 600`으로 권한을 제한하여 보안을 강화.
3. **검증:** `GOOGLE_APPLICATION_CREDENTIALS` 환경 변수가 올바른 경로를 가리키는지 확인.



---

> **오늘의 교훈:** 에러 로그는 거짓말을 하지 않는다. `UnrecognizedPropertyException`은 **API 명세서(Contract)**를 다시 보라는 신호이고, `Invalid JWT`는 **인프라 설정(Configuration)**을 점검하라는 신호다. 코드를 수정하기 전에 **'데이터가 오가는 규약'**과 **'권한'**을 먼저 의심하자.
