# Today I Learned (TIL)

**Date:** 2026. 01. 28
**Topic:** `CI/CD`, `Nginx`, `Docker`, `Swagger`, `Troubleshooting`

---

## 1. Nginx 리버스 프록시와 Path Stripping의 미학

### 🚨 문제 상황: "경로가 두 번 붙어요" (`/api/api/...`)

Nginx를 도입하여 `/dev-api` 경로를 백엔드로 연결하려 했으나, Swagger와 프론트엔드 요청 시 URL 중간에 `/api`가 중복되어 **404/500 에러**가 발생했다.

* **원인:**
1. **Swagger/FE:** 이미 `/api`를 포함한 경로(`.../api/account`)로 요청을 보냄.
2. **Nginx:** 들어온 요청에 또 `/api`를 붙여서 백엔드에 전달함.
3. **결과:** `/dev-api/api/account` -> `/api/api/account` (중복 발생)



### 💡 해결: Trailing Slash(`/`)의 마법

`rewrite` 같은 복잡한 정규식 대신, **`proxy_pass`의 끝에 `/`를 붙이는 것**만으로 해결했다.

```nginx
# Bad (복잡하고 실수하기 쉬움)
location /dev-api/ {
    rewrite ^/dev-api/(.*) /api/$1 break; 
    proxy_pass http://backend:8080;
}

# Good (깔끔한 해결책)
location /dev-api/ {
    # 끝에 /를 붙이면, location에 매칭된 경로(/dev-api/)를 자동으로 잘라내고 보낸다.
    proxy_pass http://backend:8080/; 
}

```

* **교훈:** Nginx에서 `proxy_pass` 뒤의 `/` 유무는 **"경로를 유지할지(없을 때)", "잘라낼지(있을 때)"**를 결정하는 결정적인 차이다.

---

## 2. Swagger 500 에러와 순환 참조 (feat. Spring Security)

### 🚨 문제 상황: 문서 페이지 접속 불가

서버는 정상적으로 떴는데, Swagger UI(`api-docs`) 접속 시 **500 Internal Server Error**가 발생하며 로그에 `StackOverflow` 또는 `DataIntegrityViolation`이 찍힘.

### 🔍 원인 분석

* **Spring Security의 `UserDetails` 구현체(`Account` 엔티티)**가 원인이었다.
* Swagger가 컨트롤러의 파라미터(`@AuthenticationPrincipal Account account`)를 분석하여 문서를 만들려고 시도함.
* 하지만 `Account` 엔티티 내부의 복잡한 연관관계와 Security 메서드들이 JSON 변환 과정에서 충돌을 일으킴.

### 💡 해결: 문서화 대상에서 제외하기

Swagger 설정에서 해당 클래스를 **"분석하지 마(Ignore)"**라고 명시하여 해결했다.

```java
// SwaggerConfig.java
static {
    // Account 클래스는 파라미터 분석에서 제외 (문서화 멈춰!)
    SpringDocUtils.getConfig().addRequestWrapperToIgnore(Account.class);
}

```

---

## 3. Docker 볼륨과 DB 스키마의 불일치

### 🚨 문제 상황: "분명 코드를 고쳤는데 에러가 나요"

Java 코드에서 `Account` 엔티티의 `address` 필드를 삭제하고 배포했으나, 회원가입 시 **"Column 'address' cannot be null"** 에러가 발생했다.

### 🔍 원인 분석

* **코드 vs DB의 시차:** 코드는 수정되어 `address`를 안 보내지만, **Docker 볼륨에 저장된 PostgreSQL DB**는 여전히 옛날 테이블 구조(`address NOT NULL`)를 유지하고 있었다.
* JPA의 `ddl-auto: update`는 **컬럼 삭제**를 자동으로 해주지 않는다.

### 💡 해결: `docker compose down -v`

데이터가 중요하지 않은 개발 단계이므로, 과감하게 볼륨을 날리고 재시작했다.

```bash
# -v 옵션: 컨테이너뿐만 아니라 연결된 '데이터 볼륨'까지 삭제
docker compose -f app/docker-compose.yml down -v

# 다시 빌드해서 실행 (새로운 DB 스키마 생성됨)
docker compose -f app/docker-compose.yml up -d --build

```

---

## 4. Grafana와 Sub-path 라우팅

### 🚨 문제 상황

`/monitor` 경로로 접속하면 Grafana 화면은 뜨는데 CSS/JS가 깨지거나 404가 뜸.

### 💡 해결: Rewrite와 Root URL 설정

Grafana는 자신이 `/monitor` 하위에 있다는 것을 모른다.

1. **Nginx:** `rewrite ^/monitor/(.*) /$1 break;`로 껍데기를 벗겨서 보냄.
2. **Grafana Env:** `GF_SERVER_ROOT_URL` 설정을 통해 자신이 서브 경로에 있음을 인지시켜야 함 (혹은 Nginx에서 완벽하게 처리).

---

> **💭 오늘의 총평**
> "설정 파일 한 줄(Slash)의 차이가 전체 시스템의 통신을 결정한다."
> 오늘은 코드 로직보다 **인프라(Nginx, Docker)와 프레임워크(Swagger) 간의 '주소 체계'를 맞추는 데** 집중했다. 특히 **Docker 볼륨 초기화(`-v`)**와 **Nginx의 `proxy_pass` 규칙**은 앞으로도 계속 써먹을 중요한 자산이 되었다.