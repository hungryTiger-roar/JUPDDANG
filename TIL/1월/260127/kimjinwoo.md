# TIL (Today I Learned)

## 2026-01-27(화)

---

## 🚀 1. Virtual Thread (Java 21)

### 기존 모델의 문제점

#### Thread-per-Request 방식의 비효율성
```java
// ❌ 기존 방식: Platform Thread
ExecutorService executor = Executors.newFixedThreadPool(200);

// 동시 접속 1만명 → 1만개 스레드 필요
// → 메모리 부족, 컨텍스트 스위칭 오버헤드
```

**문제점:**
- 🔴 Thread 생성 비용이 높음 (약 1MB/thread)
- 🔴 OS Thread와 1:1 매핑 → 생성 개수 제한
- 🔴 컨텍스트 스위칭 오버헤드

#### Reactive 프로그래밍의 한계
```java
// WebFlux (Reactive)
public Mono getUser(String id) {
    return webClient.get()
        .uri("/users/" + id)
        .retrieve()
        .bodyToMono(User.class)
        .flatMap(user -> 
            webClient.get()
                .uri("/orders/" + user.getId())
                .retrieve()
                .bodyToMono(Orders.class)
                .map(orders -> {
                    user.setOrders(orders);
                    return user;
                })
        );
}
```

**문제점:**
- 🔴 높은 러닝 커브 (비동기 체인 이해 필요)
- 🔴 라이브러리 호환성 이슈
- 🔴 디버깅 어려움
- 🔴 기존 동기 코드 마이그레이션 비용

---

### ✨ Virtual Thread의 해결책
```java
// ✅ Virtual Thread 사용
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    // 수백만 개의 Virtual Thread도 문제없음!
    IntStream.range(0, 1_000_000).forEach(i -> {
        executor.submit(() -> {
            Thread.sleep(Duration.ofSeconds(1));
            return i;
        });
    });
}

// ✅ 간단한 생성
Thread.startVirtualThread(() -> {
    System.out.println("Virtual Thread!");
});
```

#### Virtual Thread의 장점

| 항목 | Platform Thread | Virtual Thread |
|------|----------------|----------------|
| **생성 비용** | ~1MB | ~1KB |
| **생성 시간** | 느림 (ms) | 빠름 (μs) |
| **최대 개수** | 수천 개 | 수백만 개 |
| **컨텍스트 스위칭** | 무거움 | 가벼움 |
| **메모리** | 높음 | 낮음 |

#### 적합한 사용 사례

**✅ 적합:**
```
- I/O 위주 작업 (DB 쿼리, API 호출, 파일 읽기)
- 높은 동시성 요구 (수천~수만 동시 요청)
- 블로킹 작업이 많은 경우
```

**❌ 부적합:**
```
- CPU 집약적 작업 (이미지 처리, 암호화)
- 짧고 빠른 작업
- 메모리 집약적 작업 (GC 부담 증가)
```

#### Spring Boot 적용 예시
```yaml
# application.yml
spring:
  threads:
    virtual:
      enabled: true  # Spring Boot 3.2+
```
```java
@Configuration
public class AsyncConfig {
    
    @Bean
    public AsyncTaskExecutor applicationTaskExecutor() {
        TaskExecutorAdapter adapter = new TaskExecutorAdapter(
            Executors.newVirtualThreadPerTaskExecutor()
        );
        return adapter;
    }
}
```

---

## 🎯 2. Stream Gatherers (Java 25)

### 진화 과정
```
Record (Java 16)
    ↓
Sealed Class/Interface (Java 17)
    ↓
Stream Gatherers (Java 25)
```

### Stream Gatherers란?

기존 Stream API를 확장하여 **커스텀 중간 연산**을 쉽게 만들 수 있게 해주는 기능
```java
// ✅ Stream Gatherers 예시
List result = Stream.of("a", "b", "c", "d", "e")
    .gather(Gatherers.windowSliding(2))  // 슬라이딩 윈도우
    .map(window -> String.join("-", window))
    .toList();
// 결과: ["a-b", "b-c", "c-d", "d-e"]

// 커스텀 Gatherer
public static  Gatherer> batching(int size) {
    return Gatherer.ofSequential(
        () -> new ArrayList(),
        Integrator.of((state, element, downstream) -> {
            state.add(element);
            if (state.size() == size) {
                downstream.push(new ArrayList<>(state));
                state.clear();
            }
            return true;
        }),
        (state, downstream) -> {
            if (!state.isEmpty()) {
                downstream.push(state);
            }
        }
    );
}
```

### 주요 활용 사례

#### 1. Record - 불변 데이터 객체
```java
// DTO
public record UserDTO(Long id, String name, String email) {}

// 설정
public record DatabaseConfig(String url, String username, String password) {}

// 이벤트
public record UserCreatedEvent(String userId, LocalDateTime createdAt) {}
```

**장점:**
- ✅ 불변성 보장
- ✅ equals, hashCode, toString 자동 생성
- ✅ 간결한 코드

#### 2. Sealed Class - 제한된 상속
```java
// 함수형 모델링
public sealed interface Result 
    permits Success, Failure {
}

public record Success(T value) implements Result {}
public record Failure(String error) implements Result {}

// 타입 안전한 처리
public void handleResult(Result result) {
    switch (result) {
        case Success(String value) -> System.out.println(value);
        case Failure(String error) -> System.err.println(error);
    }
    // 컴파일러가 모든 케이스를 확인!
}
```

**장점:**
- ✅ 타입 안전성
- ✅ 패턴 매칭과 궁합
- ✅ 명시적인 계층 구조

#### 3. Stream - 안전한 데이터 변환
```java
// 안전한 변환 파이프라인
List orders = orderRepository.findAll().stream()
    .filter(order -> order.getStatus() == Status.COMPLETED)
    .gather(Gatherers.windowFixed(10))  // 10개씩 묶기
    .flatMap(Collection::stream)
    .map(OrderDTO::from)
    .toList();
```

**장점:**
- ✅ 선언적 코드
- ✅ 멀티스레드 활용 쉬움 (parallelStream)
- ✅ 함수형 프로그래밍 패러다임

---

## 🔄 3. Record Pattern (Java 21)

### 패턴 매칭의 진화
```java
// ❌ Before (Java 16)
if (obj instanceof Point) {
    Point p = (Point) obj;
    int x = p.x();
    int y = p.y();
    System.out.println(x + y);
}

// ✅ After (Java 21)
if (obj instanceof Point(int x, int y)) {
    System.out.println(x + y);  // 바로 사용!
}
```

### Switch 표현식과 결합
```java
public record Point(int x, int y) {}
public record Circle(Point center, int radius) {}

String describe(Object obj) {
    return switch (obj) {
        case Point(int x, int y) -> 
            "Point at (%d, %d)".formatted(x, y);
        case Circle(Point(int x, int y), int r) -> 
            "Circle at (%d, %d) with radius %d".formatted(x, y, r);
        case null -> "null";
        default -> "Unknown";
    };
}
```

**장점:**
- ✅ 형 변환 불필요
- ✅ 중첩 구조 분해 가능
- ✅ null 안전성
- ✅ 가독성 향상

---

## 🐍 Python 최신 기능

### 📌 버전 타임라인
- **Python 3.10** - 2021.10.04
- **Python 3.11** - 2022.10.24
- **Python 3.12** - 2023.10.02
- **Python 3.13** - 2024.10.07
- **Python 3.14** - 2025.10.07 (예정)

---

## 🚀 1. No GIL Python (Python 3.13+)

### GIL(Global Interpreter Lock)이란?
```python
# ❌ 기존: GIL 때문에 멀티스레드가 병렬 실행 안 됨
import threading

def cpu_bound_task():
    total = 0
    for i in range(10_000_000):
        total += i
    return total

# 2개 스레드가 실제론 순차 실행됨 (GIL)
threads = [
    threading.Thread(target=cpu_bound_task)
    for _ in range(2)
]
```

### No GIL의 변화
```python
# ✅ Python 3.13+ (실험적 기능)
# --disable-gil 플래그로 실행

# 진짜 병렬 실행 가능!
import sys
print(sys._is_gil_enabled())  # False

# CPU 바운드 작업에서 성능 향상
```

**주의사항:**
- ⚠️ 아직 실험적 기능 (프로덕션 비권장)
- ⚠️ C 확장 라이브러리 호환성 이슈
- ⚠️ 메모리 사용량 증가 가능성

**언제 유용한가?**
```
✅ CPU 집약적 작업 (이미지 처리, 데이터 분석)
✅ 멀티코어 활용이 필수적인 경우
❌ I/O 바운드 작업 (이미 asyncio로 해결 가능)
```

---

## 📝 2. Type Hint 강화 (Python 3.5+)

### 기본 Type Hint
```python
# ✅ 함수 타입 명시
def greet(name: str) -> str:
    return f"Hello, {name}!"

# ✅ 변수 타입 명시
age: int = 25
names: list[str] = ["Alice", "Bob"]
user_map: dict[str, int] = {"Alice": 1, "Bob": 2}
```

### 고급 타입 (Python 3.10+)
```python
from typing import Optional, Union, Literal

# Union 타입 (Python 3.10+ 간소화)
def process(value: int | str) -> str:  # Union[int, str]
    return str(value)

# Optional (None 허용)
def find_user(user_id: int) -> Optional[User]:
    return users.get(user_id)

# Literal (특정 값만 허용)
def set_mode(mode: Literal["dev", "prod"]) -> None:
    pass
```

### 실무 활용: FastAPI
```python
from fastapi import FastAPI
from pydantic import BaseModel

class UserCreate(BaseModel):
    username: str
    email: str
    age: int

app = FastAPI()

@app.post("/users")
async def create_user(user: UserCreate):
    # ✅ 자동 검증
    # ✅ 자동 문서 생성
    # ✅ IDE 자동완성
    return {"id": 1, **user.dict()}
```

### Type Checker 활용
```bash
# mypy로 타입 검사
pip install mypy
mypy main.py

# pyright (더 빠름, VSCode 기본)
pip install pyright
pyright main.py
```

**장점:**
- ✅ **정적 분석** → 런타임 오류 사전 방지
- ✅ **가독성 향상** → 코드만 봐도 의도 파악
- ✅ **자동 완성** → IDE 지원 강화
- ✅ **문서화** → 자동 문서 생성 가능
- ✅ **리팩토링** → 안전한 코드 변경

---

## ❗ 3. 친절한 Error Messages (Python 3.10+)

### Before (Python 3.9)
```python
# ❌ 이전 에러 메시지
>>> users["Alice"]["age"]
Traceback (most recent call last):
  File "", line 1, in 
KeyError: 'Alice'
```

### After (Python 3.10+)
```python
# ✅ 개선된 에러 메시지
>>> users["Alice"]["age"]
Traceback (most recent call last):
  File "", line 1, in 
KeyError: 'Alice'
    ^^^^^^^^^^^^
    Did you mean: 'alice'?
```

### 구체적인 개선 사항

#### 1. 괄호 매칭 에러
```python
# Before
>>> result = (a + b
SyntaxError: invalid syntax

# After (3.10+)
>>> result = (a + b
SyntaxError: '(' was never closed
                ^
```

#### 2. 들여쓰기 에러
```python
# Before
>>> def foo():
... x = 1
IndentationError: expected an indented block

# After (3.10+)
>>> def foo():
... x = 1
IndentationError: expected an indented block after function definition
    ^^^^^
```

#### 3. AttributeError 개선
```python
# Before
>>> "hello".upper
AttributeError: 'str' object has no attribute 'upper'

# After (3.10+)
>>> "hello".upper
AttributeError: 'str' object has no attribute 'upper'
Did you mean: 'upper()'?
```

#### 4. NameError 개선
```python
# Before
>>> print(nmae)
NameError: name 'nmae' is not defined

# After (3.10+)
>>> print(nmae)
NameError: name 'nmae' is not defined. Did you mean: 'name'?
```

---

## 🎯 실무 적용 가이드

### Java 프로젝트에서
```java
// ✅ Virtual Thread + Record + Sealed Class 조합
public sealed interface ApiResponse 
    permits Success, Error {}

public record Success(T data) implements ApiResponse {}
public record Error(String message, int code) implements ApiResponse {}

@Service
public class UserService {
    
    // Virtual Thread로 동시 처리
    public CompletableFuture<List> getAllUsers() {
        return CompletableFuture.supplyAsync(() -> {
            // I/O 작업 (Virtual Thread가 효율적)
            return userRepository.findAll();
        }, Executors.newVirtualThreadPerTaskExecutor());
    }
}
```

### Python 프로젝트에서
```python
# ✅ Type Hint + Pydantic 조합
from pydantic import BaseModel, validator
from typing import Optional

class User(BaseModel):
    username: str
    email: str
    age: int
    
    @validator('age')
    def age_must_be_positive(cls, v):
        if v < 0:
            raise ValueError('age must be positive')
        return v

# FastAPI에서 사용
@app.post("/users", response_model=User)
async def create_user(user: User):
    return user
```

---

## 📊 버전별 핵심 기능 요약

### Java

| 버전 | 핵심 기능 | 특징 |
|------|----------|------|
| **17 (LTS)** | Sealed Classes, Pattern Matching | 타입 안전성 강화 |
| **21 (LTS)** | Virtual Thread, Record Pattern | 동시성 혁신 |
| **25** | Stream Gatherers | 함수형 프로그래밍 강화 |

### Python

| 버전 | 핵심 기능 | 특징 |
|------|----------|------|
| **3.10** | 패턴 매칭, 개선된 에러 | 가독성 향상 |
| **3.11** | 성능 개선 (25% 빠름) | 실행 속도 향상 |
| **3.12** | f-string 개선 | 문자열 처리 강화 |
| **3.13** | No GIL (실험적) | 진짜 병렬 처리 |

---

## 💡 핵심 요약

### Java
1. **Virtual Thread** → 높은 동시성 처리 (I/O 위주)
2. **Record** → 불변 데이터 객체
3. **Sealed Class** → 타입 안전한 계층 구조
4. **Stream Gatherers** → 강력한 데이터 변환

### Python
1. **No GIL** → 진짜 멀티스레딩 (CPU 위주)
2. **Type Hint** → 안전하고 읽기 쉬운 코드
3. **친절한 에러** → 빠른 디버깅
4. **Pydantic** → 실무 타입 검증

---