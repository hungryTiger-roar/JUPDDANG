# TIL (Today I Learned)

## 2026-01-20(화)

---

## PostgreSQL

---

### PostGreSQL 이란?

- 객체-관계형 데이터베이스 관리 시스템(Object-Relational DBMS)
- 단순한 CRUD 중심 DB라기보다 데이터 무결성, 확장성, 복잡한 쿼리 처리에 강점을 가진 DB
- SQL 표준을 매우 충실하게 구현
- 대규모 서비스, 금융, 데이터 분석, GIS 등에서 많이 사용

---

### 핵심 개념

- 객체-관계형 DB (ORDBMS)
    - 테이블 + 관계형 모델
    - 사용자 정의 타입, 함수, 상속, 확장 기능까지 지원
    - 단순한 테이블 DB가 아니라 확장 가능한 데이터 플랫폼이다.
- MVCC (Multi-Version Concurrency Control)
    - 읽기와 쓰기가 서로 막지 않음
    - 트랜잭션 충돌이 적음
    - 롤백 / 일관성에 매우 강함
    - 동시성 높은 서비스에서 안정적
- 확장성 (Extension)
    - PostGIS (지도/GIS)
    - Full Text Search
    - JSONB
    - 사용자 정의 함수(UDF)
    - Custom Index (GIN, GiST 등)

---

### 장점

- SQL 표준 준수도가 매우 높아 복잡한 쿼리 작성에 유리
    - CTE (WITH)
    - Window Function
    - Subquery
    - Complex JOIN
- JSON / JSONB 지원이 강력
    - NoSQL + SQL 중간 느낌
- 데이터 무결성에 매우 강해 금융, 정산, 통계 서비스에 선호
    - 엄격한 타입
    - 제약 조건
    - 트랜잭션 안정성
- 대규모 / 복잡한 시스템에 적합
    - 분석 쿼리
    - 통계
    - 리포팅
    - 다중 조건 필터링

---

### 단점

- 러닝 커브 높음
    - 설정이 많음
    - 쿼리 튜닝 난이도 높음
    - 초보자에게는 무거움
- 단순 CRUD 성능은 MySQL이 나을 수 있음
    - 웹 서비스의 단순 조회/저장이 많은 경우
    - 빠른 개발 위주 프로젝트

---

### PostgreSQL vs MySQL

| 항목 | PostgreSQL | MySQL |
| --- | --- | --- |
| DB 유형 | 객체-관계형(ORDBMS) | 관계형(RDBMS) |
| SQL 표준 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| 복잡한 쿼리 | 매우 강함 | 보통 |
| JSON 처리 | 매우 강함 (JSONB) | 보통 |
| 트랜잭션 | 매우 안정적 | 안정적 |
| 성능 (CRUD) | 좋음 | ⭐⭐⭐⭐ |
| 확장성 | 매우 높음 | 보통 |
| 러닝커브 | 높음 | 낮음 |
| 웹 서비스 | ⭕ | ⭐⭐⭐⭐⭐ |
| 분석 / 통계 | ⭐⭐⭐⭐⭐ | ⭐⭐ |
### PostgreSQL은 SQL 표준 준수와 복잡한 쿼리, 분석 / 통계에 강점
### MySQL은 단순 CRUD 중심의 웹 서비스에 높은 생산성과 성능

---

### PostgreSQL 추천

- 랭킹 / 분석 / 통계
- GIS / 위치 기반 서비스
- 복잡한 JOIN / 서브쿼리
- JSON 기반 데이터 구조
- 금융 / 정산 / 데이터 무결성 중요

---

### MySQL 추천

- 일반 웹 서비스
- CRUD 위주
- 빠른 개발
- 개발 팀이 MySQL에 익숙
- 운영 단순성 중요

---