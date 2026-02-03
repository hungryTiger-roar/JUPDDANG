# 김강연 Today I Learned

---

## 1월 29일

## 🚀 오늘 한 일
### 1. 팔로우(Follow) 시스템 구축
- **기능 구현**: 팔로우/언팔로우 토글 로직 및 팔로워/팔로잉 목록 조회 API 개발
- **프로필 연동**: 유저 프로필 조회 시 팔로우 여부(`isFollowing`)와 팔로워/팔로잉 카운트 정보를 실시간으로 포함하도록 `AccountResponse` 개선

### 2. SNS 피드 팔로우 연동
- **팔로우 피드**: 전체 게시글 조회 대신, 내가 팔로우하는 유저들의 게시글만 필터링하여 최신순으로 보여주는 기능 구현
- **Repository 확장**: 특정 유저 리스트(`List<Account>`)를 조건으로 게시글을 조회하는 `findAllByAccountInOrderByCreatedAtDesc` 쿼리 메서드 추가

---

## 🛠 트러블슈팅 (Troubleshooting)

### ❌ Issue 1: `BadCredentialsException` 발생
- **원인**: 로그인 시 입력한 비밀번호와 DB의 암호화된 비밀번호가 일치하지 않음
- **해결**: Postman 요청 Body의 계정 정보 재확인 및 DB 데이터 정합성 체크로 해결

### ❌ Issue 2: `Ambiguous mapping` 에러로 인한 서버 기동 실패
- **원인**: `SnsController` 내부에 동일한 경로(`GET /api/posts`)를 가진 메서드가 두 개 존재함
- **해결**: 중복되는 기존 조회 메서드를 삭제하고 팔로우 피드 조회 메서드로 단일화하여 해결

### ❌ Issue 3: `@Transactional(readOnly = true)` 속성 인식 불가
- **원인**: `jakarta.transaction.Transactional` 패키지 임포트 (해당 패키지는 `readOnly` 미지원)
- **해결**: `org.springframework.transaction.annotation.Transactional`로 변경하여 해결


---

## 💡 배운 점
- **Spring Security 연동**: `@AuthenticationPrincipal`을 사용하여 컨트롤러 단에서 안전하고 간편하게 로그인 유저 정보를 주입받는 법을 익힘
- **협업용 API 설계**: 프론트엔드와 연동 시 URL 경로 설계(예: `/api/follow/followers`)의 중요성을 다시금 깨달음