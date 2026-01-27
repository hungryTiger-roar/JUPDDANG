# 김강연 Today I Learned

---

## 1월 26일

### 1. 주요 작업 내용
공공데이터를 기반으로 쓰레기통 위치를 제공하고, 사용자가 직접 정보를 추가/인증하는 시스템의 핵심 로직을 구현했습니다.

#### 데이터 구축 및 조회 API
- **공공데이터 로드**: 3,000여 개의 공공 쓰레기통 CSV 데이터를 파싱하여 DB에 초기 적재 성공 (인코딩: `EUC-KR`).
- **영역 기반 조회**: 지도 화면의 위도/경도 범위를 파라미터로 받아 해당 영역 내 쓰레기통만 반환하는 API 구현.

#### 사용자 위치 제안 API
- 사용자가 지도에서 직접 쓰레기통을 제안하는 기능 구현 (`PENDING` 상태로 저장).
- `JWT` 토큰 기반 인증을 적용하여 `reportedBy`에 제안자 정보 기록.

#### 쓰레기통 검증(Verify) 시스템
- **신뢰도 강화**: 3명 이상의 사용자가 검증 시 `VERIFIED` 상태로 자동 전환되는 로직 구현.
- **중복 방지**: 동일 사용자가 한 쓰레기통을 여러 번 검증할 수 없도록 `UniqueConstraint` 및 별도 이력 테이블 관리.

#### ✅ Story 6: 사용자 활동 내역 조회
- 내가 제안한 쓰레기통 목록을 최신순으로 조회하는 API 구현.
- `status`별(PENDING, VERIFIED 등) 필터링 기능 지원.

---

### 2. 주요 트러블슈팅
- **IntelliJ 캐시**: 코드 수정 후에도 이전 에러가 반복되는 현상 → `Invalidate Caches`를 통해 IDE 인덱스 초기화 후 해결.
- **Spring Security**: 신규 API 엔드포인트 접근이 차단되는 문제 → `SecurityConfig` 내 `requestMatchers` 설정 수정을 통해 인증 범위 조정.
- **Lombok/Record 혼용**: JPA Entity는 `record` 사용이 불가하여 수동 Getter/Setter 구성, DTO는 `record`를 사용하여 불변성 확보.

---

### 3. 배운 점
- Spring Security에서 `@AuthenticationPrincipal`을 사용할 때, `JwtTokenProvider`에서 설정한 인증 객체의 타입(String vs Object)이 컨트롤러 파라미터와 일치해야 함을 체득함.
- 대용량 데이터(CSV) 적재 시 `saveAll`을 통한 배치 처리의 중요성을 깨달음.