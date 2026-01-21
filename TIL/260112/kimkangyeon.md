# 김강연 Today I Learned

---

## 1월 12일

## Java 코드 컨벤션 (Spring Boot)

### 학습 배경
팀 프로젝트에서 코드 스타일 통일을 위해 Java 코드 컨벤션 학습

---

### 네이밍 규칙

#### 기본 원칙
```java
// 클래스/인터페이스: PascalCase
public class UserController { }
public interface UserRepository { }

// 메서드/변수: camelCase
public User getUser(Long userId) { }
private final UserService userService;

// 상수: UPPER_SNAKE_CASE
private static final int MAX_SIZE = 100;

// 패키지: lowercase
package com.ssafy.mamy.domain.user.controller;
```

#### 클래스 네이밍 패턴
```java
// Entity: 명사
public class User { }

// Service: 명사 + Service
public class UserService { }

// Controller: 명사 + Controller
public class UserController { }

// DTO: 명사 + 용도 + Dto
public class UserResponseDto { }
public class UserCreateRequest { }

// Exception: 명사 + Exception
public class UserNotFoundException extends RuntimeException { }
```

#### 메서드 네이밍
```java
// get: 조회 (반드시 존재)
public User getUser(Long id) { }

// find: 검색 (없을 수도 있음)
public Optional<User> findUserByUsername(String username) { }

// create/update/delete: CRUD
public User createUser(UserDto dto) { }

// is/has: boolean 반환
public boolean isAdmin(User user) { }
```

---

### 코드 스타일 선택

#### Google Java Style vs Naver Convention

| 항목 | Google | Naver |
|------|--------|-------|
| 들여쓰기 | 2 스페이스 | 4 스페이스 |
| 한 줄 길이 | 100자 | 120자 |
| 국제 표준 | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| 도구 지원 | 우수 | 부족 |

---

### 포맷팅 규칙

```java
// 들여쓰기: 4 스페이스
public class UserService {
    
    private final UserRepository userRepository;
    
    // 중괄호: K&R 스타일 (같은 줄에서 시작)
    public User getUser(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID는 필수입니다");
        }
        return userRepository.findById(id).orElseThrow();
    }
}

// 연산자 앞뒤 공백
int result = a + b;

// 쉼표 뒤 공백
List<String> list = Arrays.asList("a", "b", "c");

// import: 와일드카드 금지
import java.util.List;  // ✅
import java.util.*;     // ❌
```

---

### Django vs Spring Boot 비교

| 도구 | Django | Spring Boot |
|------|--------|-------------|
| 자동 포맷팅 | black | IntelliJ Reformat |
| 검증 | ruff check | Checkstyle |
| 에디터 설정 | .editorconfig | .editorconfig |

---