## 📅 2026. 02. 02

### 1. Spring DI 컨테이너와 Bean 충돌 해결: RedisTemplate의 모호성

테스트 코드 실행 중 발생한 `UnsatisfiedDependencyException`을 통해 Spring 컨테이너의 의존성 주입 원리를 재확인했습니다.

#### 📌 다중 DataSource 환경에서의 Bean 식별자(Qualifier)

* **문제 상황 (Issue)**
* `redisTemplate`(기본)과 `rankingRedisTemplate`(랭킹용) 두 개의 Bean이 공존하여 주입 대상 충돌 발생.


* **원인 분석 (Cause)**
* Spring의 Bean 탐색 순서(Type -> Name)에서 식별자가 불명확하여 발생한 **'의존성 모호성(Ambiguity)'**.


* **해결 전략 (Solution)**
* **명시적 주입(Explicit Injection):** `@Qualifier` 사용 또는 필드명을 Bean 이름과 일치시켜 모호성 제거.
* **검증:** 디버깅을 통해 의도한 Bean이 주입되는지 확인.



> **💡 오늘의 교훈**
> **"모호함(Ambiguity)을 제거하는 것이 안정성의 시작이다."**
> 백엔드에서의 **'Bean 이름 하나'**가 애플리케이션 구동 전체를 막을 수 있다. **명확한 식별자(Identifier)**를 사용하는 습관은 컨테이너가 헷갈리지 않게 돕는 친절함이자, 시스템의 예측 가능성을 높이는 기본 원칙이다.