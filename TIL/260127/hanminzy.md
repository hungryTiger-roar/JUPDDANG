# Today I Learned
**Date:** 2026.01.27

---
## 1. 최신 언어 트렌드: Java & Python
**핵심 키워드:** 안정성, 성능, 편의성 (빠르고, 안전한 코드를, 편하게)

### 버전 흐름
- **Java:** Ver.17 (LTS, 2021) ➡️ Ver.25 (Future, 2025)
- **Python:** 3.x ➡️ 3.13~ (No GIL), 3.14 (Performance Boost)

---

### 🚀 성능 향상을 위한 최신 기능

#### #1 Java Virtual Thread (JDK 21)


- **기존 문제:** `Thread-per-request` 방식의 비효율성 (OS 스레드 1:1 매핑).
- **해결:** **Virtual Thread** 도입 (JVM 내부 스케줄링).
- **장점:**
  - Thread 생성 및 문맥 전환(Context Switch) 시간 감소.
  - Thread 생성 Limit 대폭 증가.
  - **I/O 위주 작업(Web Server 등)에 적합.**
- **주의:** CPU 연산 위주 작업에는 성능 저하 가능성, GC 부담 증가.

#### #2 Python No GIL (3.13~)


- **기존 문제:** **GIL (Global Interpreter Lock)** 때문에 멀티 스레드를 써도 실제로는 하나의 스레드만 동작.
- **변화:** 3.13부터 `Free-threaded` 지원, 3.14부터 본격적인 성능 향상.
- **장점:** **True Multi-threading** 가능.
- **대안 (Alternatives):** `asyncio`, `multiprocessing`.

---

### 🛡️ 안전을 위한 최신 기능

#### #3 Java 불변성 강화
- **Record (16):** DTO, 이벤트를 위한 불변 객체.
- **Sealed Class (17):** 상속 가능한 클래스를 제한하여 타입 안정성 보장.
- **Stream Gatherers (25):** 스트림 파이프라인의 안전한 변환.
- **효과:** 멀티 스레드 환경에서 안전하고, 가독성 높은 함수형 스타일 코드 작성.

#### #4 Python Type Hint (3.5~)
- **특징:** 자유로운 동적 타이핑 + 안전한 정적 타이핑의 조화.
- **장점:** 정적 분석을 통한 런타임 오류 방지, IDE 자동완성 지원.
- **도구:** `mypy`, `pyright`, `pydantic` (FastAPI).

---

### 🛠️ 편의성을 위한 최신 기능

#### #5 Java Record Pattern (JDK 21)
형변환과 데이터 추출을 동시에 처리.

```java
// Java 16 이전 (명시적 캐스팅 필요)
if (obj instanceof Point) {
    Point p = (Point) obj;
    int x = p.x();
}

// Java 21 (Record Pattern)
if (obj instanceof Point(int x, int y)) {
    // x, y를 바로 사용 가능
    System.out.println(x + y);
}
```
## 2. 랭킹 UI/UX 대응을 위한 API 리팩토링

### 변경 사항 요약

- Redis ZSet 기반 실시간 랭킹 시스템 구현
  * PloggingRedisRepository: 누적/월간 랭킹 점수 업데이트 및 Top 3, 윈도우(내 순위 ±2) 조회 기능 추가 (Sorted Set 활용).
  * RankingService: Redis에서 랭킹 정보를 조회하고 DB(AccountRepository)에서 유저 상세 정보를 매핑하는 하이브리드 로직 구현.
- Account 엔티티 및 DB 스키마 리팩토링
  * Account 엔티티: score 필드명을 totalScore로 변경하여 의미 명확화, tier 필드 신규 추가.
  * AccountResponse: 변경된 필드(totalScore, tier)가 응답에 포함되도록 DTO 수정.
- API 엔드포인트 및 로직 수정
  * RankingController: 기존 페이징(page, size) 방식 제거 → "Top 3 + 내 주변 랭킹" 조회 방식으로 변경.
  * PloggingScoreListener: 플로깅 종료 시 DB 저장 후 Redis 랭킹 점수도 동기화되도록 로직 추가.

### 관련 이슈

- Related to # S14P11D208-160
- Closes # S14P11D208-182 (Account 엔티티 스키마 수정)
- Closes # S14P11D208-161 (기획/설계 확정)
- Closes # S14P11D208-164 (랭킹 응답 구조 변경)
- Closes # S14P11D208-165 (Repository 쿼리 구현)
- Closes # S14P11D208-171 (랭킹 윈도우 계산 로직)
- Closes # S14P11D208-178 (Controller 연결)

### 작업 유형

- [x] :sparkles: 신규 기능 추가
- [ ] :bug: 버그 수정
- [x] :recycle: 리팩토링
- [ ] :books: 문서 업데이트
- [ ] :gear: 빌드/배포 스크립트 수정
- [ ] :test_tube: 테스트 추가/수정

### 테스트 계획 및 결과

- [x] 로컬 단위 테스트 수행
- [x] 개발 서버 배포 후 기능 동작 확인
    * `GET /api/ranking/total`: 전체 랭킹 조회 시 Top 3와 내 주변 순위가 정상 반환되는지 확인.
    * `GET /api/ranking/monthly`: 월간 랭킹 데이터가 정상 조회되는지 확인.
    * 플로깅 종료 후 점수와 티어가 Redis 및 DB에 즉시 반영되는지 확인.

### 기타 특이사항

- DB 스키마 변경 주의: account 테이블의 score 컬럼이 total_score로 변경되었으며, tier 컬럼이 추가되었습니다. 실행 전 확인 부탁드립니다.
- 랭킹 데이터는 Redis(ranking:total, ranking:monthly:YYYYMM)를 참조하므로, 초기 데이터가 없을 경우 랭킹이 비어 보일 수 있습니다. (플로깅 1회 수행 시 자동 등록됨)

### 체크리스트 (선택)

- [x] 엔티티 변경에 따른 DTO 및 Repository 메서드명 동기화 확인 완료
- [x] 불필요한 페이징 파라미터 제거 확인 완료

Related to S14P11D208-160