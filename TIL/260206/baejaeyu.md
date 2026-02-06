## 📅 2026. 02. 06

### Nginx 리버스 프록시 환경에서 WebSocket 핸드셰이크 실패 해결

Spring Boot SockJS WebSocket 연결 시 nginx를 통과하면서 `Upgrade` 헤더가 유실되어 핸드셰이크가 실패하는 문제를, **nginx 설정 분석**과 **클라이언트 경로 매핑**을 통해 해결하고 프로덕션 환경의 실시간 통신 안정성을 확보했습니다.

#### 📌 리버스 프록시 환경의 WebSocket 프로토콜 전환 문제

* **문제 상황 (Issue)**
  * Spring Boot 백엔드에서 `"Handshake failed due to invalid Upgrade header: null"` 에러가 지속적으로 발생.
  * Flutter 앱의 SockJS 클라이언트가 `/dev-api/ws/` 경로로 연결을 시도하지만, HTTP 400 Bad Request로 실패.
  * nginx는 기본적으로 **hop-by-hop 헤더**(`Upgrade`, `Connection`)를 다음 프록시로 전달하지 않아, WebSocket 프로토콜 전환(HTTP → WS)이 불가능한 상황.

* **해결 전략 (Solution)**
  * **nginx 설정 분석:** 기존 `/dev-api/` location은 일반 REST API 전용으로 WebSocket 헤더 설정이 누락되어 있음을 확인.
  * **WebSocket 전용 경로 추가:** `/dev-api/ws/` location을 별도로 생성하고 다음 설정 적용:
    ```nginx
    location /dev-api/ws/ {
        proxy_pass http://jupddang-backend-dev:8080/ws/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
    ```
  * **프로토콜 요구사항 충족:** `proxy_http_version 1.1` 설정으로 HTTP/1.1 프로토콜 명시 (WebSocket 필수 조건).
  * **타임아웃 조정:** 실시간 연결 유지를 위해 `read_timeout`과 `send_timeout`을 3600초로 설정.

> **💡 오늘의 교훈**
> **"프로토콜은 계층마다 명시적으로 전환되어야 한다."**
> 리버스 프록시는 단순히 요청을 전달하는 것이 아니라, 프로토콜 전환의 중재자 역할을 한다. HTTP에서 WebSocket으로의 업그레이드는 자동으로 일어나지 않으며, 각 계층(nginx, backend)에서 명시적으로 헤더를 전달하고 처리해야 비로소 실시간 통신이 가능해진다. 인프라 설정은 '동작하면 끝'이 아니라, '왜 동작하는지'를 이해하는 과정이다.
