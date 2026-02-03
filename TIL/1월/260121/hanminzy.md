# Today I Learned
**Date:** 2026.01.21

---
## 백엔드 계층 구조 (Layered Architecture)

Spring Boot와 같은 백엔드 프레임워크에서 역할에 따라 코드를 분리하는 구조.

| **계층 (이름)** | **역할 (비유)** | **상세 설명** |
| :--- | :--- | :--- |
| **Controller** | **점원** (주문) | 클라이언트(Flutter)의 요청을 받아 적절한 서비스로 넘기고, 결과를 응답함. |
| **Service** | **요리사** (로직) | 앱의 핵심 **비즈니스 로직**을 수행 (예: 점수 계산, 땅 점유 판정 등). |
| **Repository** | **창고 관리자** | 데이터베이스(DB)에 접근하여 데이터를 저장(Save)하거나 조회(Find)함. |
| **Entity** | **창고 물품** (DB) | DB 테이블과 1:1로 매핑되는 클래스 (DB 설계도). |
| **DTO** | **포장 상자** | 계층 간 데이터 전달용 객체. Entity(원본)를 보호하기 위해 별도로 사용. |

---

## 2. SNS API 구현 작업 로그

### 주요 기능 명세
- **GET** `/api/posts` : 전체 포스트 조회
- **POST** `/api/posts/{postid}/like` : 포스트 좋아요
- **DELETE** `/api/posts/{postid}` : 포스트 삭제
- **POST** `/api/posts/{postid}/comment` : 댓글 작성
- **DELETE** `/api/posts/{postid}/{commentid}` : 댓글 삭제

### 변경 사항 요약 (Change Log)
- **Feat:** SNS 게시글 및 댓글 기능 컨트롤러(`SnsController`) 구현.
- **Fix:** Entity 및 DTO 매핑 오류 수정.
- **Related Issue:** Fixes #S14P11D208-40

### 트러블 슈팅 (Troubleshooting)
1. **양방향 매핑 오류:**
   - Post - Comment 간 `mappedBy` 변수명 불일치 해결.
2. **DB 예약어 충돌:**
   - `like` 컬럼은 SQL 예약어이므로 쿼리 충돌 발생.
   - **해결:** 컬럼명을 변경하거나 쿼리 작성 시 백틱(\`) 이스케이프 처리 필요.
3. **DTO 타입 불일치:**
   - Controller의 Request/Response와 DTO 타입이 맞지 않는 문제 수정.

### 테스트 결과
- 로컬 단위 테스트 수행 완료.
- 개발 서버 배포 후 기능 동작 확인.
- H2 DB에 더미 데이터 20개 삽입 후 `OrderByCreatedAtDesc` 정렬 동작 확인 완료.


---

## 3. 개발 팁: DB 없는 경우 테스트 방법 (H2)

로컬 환경에서 외장 DB 없이 **In-Memory DB(H2)를** 사용하여 테스트하는 환경 구축.

### build.gradle에 추가
    ```runtimeOnly 'com.h2database:h2'```
- security관련은 주석

### application.properties 에 추가

```
spring.datasource.url=jdbc:h2:mem:jupddang
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.hibernate.ddl-auto=update
```

위와 같이 설정하고 
http://localhost:8080/h2-console
로 접속하면 임의의 DB공간에서 테이블에 데이터를 insert할 수 있다.