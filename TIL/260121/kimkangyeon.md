# 김강연 Today I Learned

---

## 1월 21일

## 1. Spring Boot 파티 초대 코드 생성 API 구현
- 6자리 랜덤 숫자 코드 생성 (`SecureRandom` 사용)
- `String.format("%06d", code)`로 앞자리 0 채우기
- Repository의 `existsByInviteCode()`로 중복 체크

## 2. Record 기반 DTO 구현
- Lombok 대신 Java Record 사용
- 불변 객체로 안전한 데이터 전달
- Compact Constructor로 유효성 검증
```java
public record InviteCodeResponse(String inviteCode, String message) {
    public InviteCodeResponse {
        if (inviteCode == null) throw new IllegalArgumentException();
    }
}
```

## 3. 전역 예외 처리
- `@RestControllerAdvice`로 전역 예외 처리
- 커스텀 예외 클래스 생성 (PartyException)
- Record로 ErrorResponse DTO 구현
