# TIL (Today I Learned)

## 2026-01-21(수)

---

## Spring Security

---

### Spring Security란?

- Spring 기반 애플리케이션에서 인증(과 인가를 담당하는 보안 프레임워크
- 모든 클라이언트 요청을 Controller 진입 전에 가로챔
- 인증 실패시 Controller 진입 자체를 차단함

---
### 인증, 인가
|구분|의미|예시|
|---|---|---|
| 인증(Authentication) | 사용자가 누구인지 확인 | 로그인 |
| 인가(Authorization) | 권한이 있는지 확인 | 관리자만 접근 |
---
### Security 실행 흐름
- **client 요청**
    - POST /api/account/login
    - Authorization: Bearer xxx.jwt.token
- **Security Filter Chain**
    - 모든 요청은 필터 체인부터 통과
    - 인증 필요 여부 확인
    - 토큰 필요 여부 확인
- **Authentication Filter**
    - 요청에서 인증 정보 추출
        - ID / PW
        - JWT Token
    - 인증 객체(Authentication) 생성 시도
- **Authentication Manager**
    - 인증 요청을 받아서 적절한 provider에게 위임
    - 최종적으로 인증 성공 / 실패 결정
- **Authentication Provider**
    - 실제 검증 로직 수행
        - 비밀번호 비교
        - 토큰 검증
    - 성공시 인증된 Authentication 반환
- **UserDetailsService**
    - 사용자 정보 조회
    - 권한(Role) 로딩
- **SecurityContext**
    - 이제 이 요청은 인증된 사용자 요청으로 처리
```java
SecurityContextHolder.getContext().setAuthentication(auth);
```
    
- **Controller 도달**
```java
@PreAuthorize("hasRole('USER')")
@PostMapping("/signup")
@ResponseStatus(HttpStatus.CREATED)
public AccountResponse signup(@RequestBody
AccountCreateRequest request) {
        return accountService.createAccount(request);
    }
```
---