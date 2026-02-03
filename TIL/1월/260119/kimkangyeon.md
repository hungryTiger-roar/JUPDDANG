# 김강연 Today I Learned

---

## 1월 19일

## 1. 공간 인덱싱: Uber H3
위치 기반 서비스의 핵심인 구역 점유 및 좌표 처리를 위해 **Uber H3** 육각형 그리드 시스템을 도입.

- **해상도(Resolution) 선정**: `Res 12` ~ `Res 14`
  - **이유**: 사용자의 상세 위치나 비교적 좁은 영역의 점유(Territory)를 표현하기 위함.
  - **참고**:
    - Res 12: 엣지 길이 약 9m
    - Res 14: 엣지 길이 약 1.3m (매우 정밀)

## 2. 데이터베이스: PostgreSQL + PostGIS
공간 데이터를 가장 효율적으로 다루기 위해 **PostgreSQL** 생태계 선택.

### 선정 이유 (vs MySQL, MongoDB)
| 기능 | PostgreSQL + PostGIS | 타 DB (MySQL, MariaDB 등) |
| :--- | :--- | :--- |
| **H3 지원** | **Native 지원** (`h3-pg` 확장) | 미지원 (애플리케이션 레벨 처리 필요) |
| **인덱스** | **GiST** (고성능 공간 인덱싱) | R-Tree (일반적 성능) |
| **공간 함수** | **1,000+ 개** | 50여 개 |
| **성능** | ⭐️⭐️⭐️⭐️⭐️ (압도적) | ⭐️⭐️⭐️ |

## 3. 백엔드 프레임워크: Spring Boot vs Django
Python(Django)에서 **Java(Spring Boot)** 비교 분석

### 비교 분석
1. **성능 & 효율성**
  - **Spring Boot**: JVM 기반. JIT 컴파일러와 가비지 컬렉션 덕분에 대용량 트래픽 처리와 연산 속도 면에서 우위.
  - **Django**: 인터프리터 언어의 한계와 GIL(Global Interpreter Lock)로 인해 멀티 스레딩 효율이 낮음.
2. **동시성 처리**
  - Spring Boot는 멀티 스레딩을 완벽하게 지원하여 고성능 처리가 가능.
3. **안정성**
  - 정적 타입 언어(Java) 특성상 컴파일 타임에 에러를 잡아내어 운영 안정성이 높음.

## 4. 백엔드 개발 환경 및 버전 전략

- **Language: JDK 21 (LTS)**
  - **Virtual Threads** 포함: 기존 스레드 모델 대비 리소스 비용 절감 및 동시성 처리 성능 비약적 향상.
- **Framework: Spring Boot 3.x**
  - JDK 17 이상 필수. 클라우드 네이티브 환경 및 GraalVM 등 최신 생태계 최적화.
- **Database**
  - PostgreSQL: 15.x 또는 16.x
  - PostGIS: 3.4.x

## 5. 참고 도구 (ERD)
- **DBeaver**: ERD 그리기 및 데이터 조회용 (무료/강력).
- **웹 기반 툴**: ERDCloud, Draw.io, dbdiagram.io 등 활용 예정.