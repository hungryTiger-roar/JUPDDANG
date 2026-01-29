# TIL (Today I Learned)

## 2026-01-29(목)

---

# TIL: 메시지 큐(Message Queue)와 RabbitMQ

> 비동기 메시징 시스템의 필요성과 RabbitMQ 활용

---

## 📨 메시지란?

**정의:**
> 애플리케이션에서 다른 애플리케이션이 이용할 수 있도록 생성하는 데이터 패킷

**기원:**
- 메시지 큐의 원조는 **운영체제(OS)**
- 프로세스 간 통신(IPC)에서 시작

---

## 🍽️ 동기 vs 비동기: 음식점 비유

### 동기 방식 (Synchronous)
```
고객 → 요리사에게 직접 주문
         ↓
    요리사 조리 중...
         ↓
    다음 주문 불가능 ❌
```

**문제점:**
- 한 번에 한 주문만 처리
- 대기 시간 증가
- 확장성 부족

---

### 비동기 방식 (Asynchronous)
```
고객 → 주문 박스 → 메시지 → 요리사
                     ↓
                 다음 주문 가능 ✅
```

**장점:**
- 여러 주문 동시 접수
- 요리사가 준비되면 처리
- 확장성 좋음

**핵심:**
> **요리사가 이해할 수 있는 주문 메시지** (표준화된 형식)

---

## 📏 메시지 경량화의 필요성

### HTTP 요청의 문제점
```http
POST /api/orders HTTP/1.1
Host: example.com
Content-Type: application/json
Accept: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
User-Agent: Mozilla/5.0
Content-Length: 150

{
  "orderId": 123,
  "item": "pizza",
  "quantity": 1
}
```

**문제:**
- ❌ 작은 메시지임에도 **상당량의 텍스트 크기**
- ❌ HTTP 헤더 오버헤드 (수백 바이트)
- ❌ 실제 데이터보다 메타데이터가 더 큼

---

### 과대 포장 문제
```
📦 HTTP 요청
┌─────────────────────────────┐
│ HTTP Headers (300 bytes)    │ ← 과대 포장
├─────────────────────────────┤
│ Actual Data (50 bytes)      │ ← 실제 데이터
└─────────────────────────────┘
```

**해결:**
> **메시징을 위한 전용 경량화 프로토콜의 필요성**
> 
> → AMQP, MQTT, STOMP 등

---

## 🚀 확장성: 폭발적인 주문량 대처

### 수평 확장 (Horizontal Scaling)
```
주문 큐
  ↓
  ├─→ 요리사 1
  ├─→ 요리사 2
  ├─→ 요리사 3
  └─→ 요리사 4
```

**원칙:**
> **주문량에 비례한 요리사 고용**
> 
> = 트래픽에 따른 워커(Worker) 증설

---

## 🎯 상태 기반 메시지 전달

### 스마트 라우팅
```
메시지 큐
  ↓
상태 확인: 조리 가능?
  ├─ ✅ 가능 → 요리사 A
  ├─ ❌ 불가 → 대기
  └─ ✅ 가능 → 요리사 B
```

**특징:**
- 조리 가능한 상태의 요리사에게만 메시지 전달
- 자원 효율적 활용
- 부하 분산

---

## 🏷️ 메시지 구분: 효율적인 정보 전달

### 새로운 장르의 요리 추가
```
주문 큐
  ├─ [한식] → 한식 요리사
  ├─ [양식] → 양식 요리사
  ├─ [중식] → 중식 요리사
  └─ [일식] → 일식 요리사
```

**장점:**
- 메시지 구분을 통한 전문화
- 효율적인 정보 전달
- 확장성 (새 장르 추가 용이)

---

## 🥣 메시지 큐의 본질

### 그릇의 본연의 기능
```
그릇 = 다른 사물과 분리하여 보관할 수 있는 공간 제공
```

### 메시지 큐의 본연의 기능
```
메시지 큐 = 애플리케이션 간 메시지를 비동기적으로 전달
```

**핵심 가치:**
- ✅ 애플리케이션 분리 (Decoupling)
- ✅ 비동기 처리
- ✅ 안정성 보장

---

## 🚗 실전 예시: 무인 주차 정산 시스템

### ❌ 단순 동기 방식의 문제
```
사용자 → 출차 요청
         ↓
    WAS에서 요금 계산
         ↓
    할인 정책 검증
         ↓
    결제 처리
         ↓
    응답 (느림...)
```

**문제점:**
- 모든 처리가 동기적으로 수행
- 응답 시간 증가
- WAS 부하 집중
- **WAS 내부적인 비동기 처리 구현의 불안정성**

---

### ✅ 메시지 큐를 활용한 비동기 처리
```
사용자 → 출차 요청
         ↓
    WAS: 빠른 응답 ✅
         ↓
    메시지 큐 → [입차 메시지]
                      ↓
                 JOB 서버
                 - 할인 정책 검증
                 - 요금 계산
                 - 결제 처리
```

**장점:**
- ✅ 빠른 응답 (즉시 리턴)
- ✅ 성능 향상
- ✅ 안정성 향상
- ✅ WAS와 JOB 서버 분리

---

### Spring Boot Async의 한계
```java
// ❌ WAS 내부 비동기 처리
@Async
public void processParking() {
    // 할인 검증
    // 요금 계산
    // 결제 처리
}
```

**문제점:**
- WAS에 부하 집중
- 장애 시 메시지 유실 가능
- 확장성 제한

**해결:**
> 사용 중인 프레임워크의 모듈 활용보다
> **메시지 큐 도입**이 더 안정적!

---

## 🔗 느슨한 결합 (Loose Coupling)

### Before: 강한 결합
```
출차 API → 할인 검증 모듈
         → 요금 계산 모듈
         → 결제 모듈
```

**문제:**
- 한 모듈 장애 시 전체 영향
- 확장 어려움

---

### After: 느슨한 결합
```
출차 API → 메시지 큐 → 할인 검증 인스턴스
                    → 요금 계산 인스턴스
                    → 결제 인스턴스
```

**장점:**
- ✅ 독립적 배포 및 확장
- ✅ 장애 격리
- ✅ 유연한 확장

**핵심:**
> **큐를 활용하여 할인 여부 체크하는 인스턴스를 분리**

---

## 🏗️ MSA 메시징 활용

### MSA 서비스 간 비동기 호출
```
주문 서비스 → [주문 생성 이벤트]
               ↓
           메시지 큐
               ↓
    ├─→ 재고 서비스 (재고 차감)
    ├─→ 결제 서비스 (결제 처리)
    ├─→ 배송 서비스 (배송 준비)
    └─→ 알림 서비스 (알림 발송)
```

**장점:**
- ✅ 서비스 간 독립성
- ✅ 확장성
- ✅ 장애 전파 방지
- ✅ 이벤트 기반 아키텍처

---

## 🐰 RabbitMQ

### 특징

**메시지 큐 본연의 기능을 지원하는 경량화 제품**
```
Producer → RabbitMQ → Consumer
            ↓
        Exchange
         ↓  ↓  ↓
       Queue Queue Queue
```

---

### 1️⃣ Exchange 라우팅

**메시지를 목적에 맞게 분기**

#### Direct Exchange
```
Message[routing_key="order"]
         ↓
    Exchange
         ↓
   Queue(order)
```

#### Topic Exchange
```
Message[routing_key="order.payment"]
         ↓
    Exchange
     ↓       ↓
Queue(order.*) Queue(*.payment)
```

#### Fanout Exchange
```
Message
  ↓
Exchange (브로드캐스트)
  ↓  ↓  ↓
 Q1  Q2  Q3
```

---

### 2️⃣ 내구성과 신뢰성

**데이터 유실 방지에 진심**
```
✅ Message Persistence (메시지 영속화)
✅ Queue Durability (큐 영속화)
✅ Publisher Confirms (발행 확인)
✅ Consumer Acknowledgements (소비 확인)
```

#### 메시지 전달 보장
```
Producer → RabbitMQ (디스크 저장)
              ↓
           Consumer
              ↓
         ACK 전송 ✅
              ↓
        메시지 삭제
```

**장애 시나리오:**
```
Consumer 처리 중 장애 발생
  ↓
ACK 미전송
  ↓
메시지 재전송 (다른 Consumer)
```

---

### 3️⃣ 다양한 환경 지원

#### 멀티 언어 지원
```
✅ Java
✅ Python
✅ Node.js
✅ Go
✅ C#
✅ Ruby
✅ PHP
```

#### 멀티 프로토콜 지원
```
✅ AMQP 0-9-1 (기본)
✅ AMQP 1.0
✅ MQTT
✅ STOMP
✅ HTTP/REST
```

---

## 🎯 RabbitMQ 핵심 개념

### 1. Producer (생산자)
```java
// 메시지 발행
channel.basicPublish(
    "exchange",     // Exchange 이름
    "routing.key",  // Routing Key
    null,           // Properties
    message.getBytes() // 메시지
);
```

### 2. Exchange (교환기)
```
메시지를 어느 큐로 보낼지 결정하는 라우터
```

### 3. Queue (큐)
```
메시지를 저장하는 버퍼
```

### 4. Consumer (소비자)
```java
// 메시지 수신
channel.basicConsume(queueName, false, 
    (consumerTag, delivery) -> {
        String message = new String(delivery.getBody());
        // 메시지 처리
        channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
    },
    consumerTag -> {}
);
```

### 5. Binding (바인딩)
```
Exchange와 Queue를 연결하는 규칙
```

---

## 💡 실전 적용 시나리오

### 시나리오 1: 주문 처리 시스템
```
사용자 주문
    ↓
Order Service (Producer)
    ↓
  [주문 이벤트]
    ↓
  RabbitMQ
    ↓
┌───┴───┬───┬───┐
│       │   │   │
재고   결제 배송 알림
Service Service Service Service
(Consumer)
```

---

### 시나리오 2: 로그 수집 시스템
```
Application Logs
    ↓
RabbitMQ (Topic Exchange)
    ↓
┌───────┬────────┬─────────┐
│       │        │         │
Error   Warn    Info     Debug
Logger  Logger  Logger   Logger
```

---

### 시나리오 3: 이메일 발송 시스템
```
회원가입/주문완료/알림
    ↓
  [이메일 큐]
    ↓
RabbitMQ (Fanout)
    ↓
┌────┬────┬────┐
│    │    │    │
W1   W2   W3   W4
(Email Workers)
```

---

## 📊 메시지 큐 vs HTTP API

| 항목 | HTTP API | Message Queue |
|------|----------|---------------|
| **통신 방식** | 동기 (Synchronous) | 비동기 (Asynchronous) |
| **결합도** | 강함 (Tight) | 약함 (Loose) |
| **응답 시간** | 즉시 응답 필요 | 지연 허용 |
| **확장성** | 제한적 | 우수 |
| **신뢰성** | 재시도 복잡 | 자동 재시도 |
| **장애 처리** | 즉시 실패 | 메시지 보존 |
| **프로토콜** | HTTP (무거움) | AMQP (경량) |

---

## 🎓 핵심 요약

### 메시지 큐의 필요성
```
1. 비동기 처리 → 응답 속도 향상
2. 느슨한 결합 → 서비스 독립성
3. 확장성 → 워커 수평 확장
4. 안정성 → 메시지 유실 방지
5. 경량화 → HTTP 오버헤드 제거
```

### RabbitMQ의 강점
```
1. Exchange 라우팅 → 유연한 메시지 분기
2. 내구성 → 데이터 유실 방지
3. 멀티 환경 지원 → 다양한 언어/프로토콜
4. 안정성 → ACK 기반 전달 보장
5. 확장성 → 클러스터링 지원
```

### 적용 시점
```
✅ MSA 서비스 간 통신
✅ 이벤트 기반 아키텍처
✅ 비동기 작업 처리 (이메일, 알림)
✅ 로그 수집 및 분석
✅ 부하가 높은 작업 분산
✅ 장애 격리가 필요한 시스템
```

---

## 🔗 참고 자료

- [RabbitMQ 공식 문서](https://www.rabbitmq.com/documentation.html)
- [AMQP 0-9-1 Model](https://www.rabbitmq.com/tutorials/amqp-concepts.html)
- [Spring AMQP](https://spring.io/projects/spring-amqp)

---

**Tags:** `#메시지큐` `#RabbitMQ` `#비동기` `#MSA` `#AMQP` `#EventDriven`

---

## 💭 마무리

**메시지 큐는 단순한 도구가 아니라:**

> "애플리케이션 간 소통의 방식을 바꾸는 패러다임"
```
동기 → 비동기
강한 결합 → 느슨한 결합
모놀리식 → MSA
HTTP 오버헤드 → 경량 프로토콜
```

**핵심 원칙:**
> 메시지 큐의 본질은 **비동기 메시지 전달**
> 
> 과대 포장하지 말고, 본연의 기능에 충실하라! ✨

---