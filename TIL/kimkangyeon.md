# 김강연 Today I Learned

---

## 1월 13일


## JMeter를 이용한 API 부하 테스트 및 성능 분석

## 1. 테스트 개요
* **목적**: 특정 API의 부하 임계점(Saturation Point) 확인 및 장애 발생 지점 분석
* **테스트 대상 API**: `GET https://i14d208.p.ssafy.io/api/posts` (전체 게시글 조회)
* **테스트 환경**: Apache JMeter 5.6.3

## 2. 테스트 설정 및 과정
### ⚙️ JMeter 구성
* **Thread Group**: 
    * Number of Threads: 3,000 (동시 접속자 수)
    * Ramp-up period: 10초 (사용자 투입 시간)
    * Loop Count: 5회 반복
* **HTTP Request**:
    * Protocol: `https` (슬래시 `//` 제외 설정 주의)
    * Server Name: `i14d208.p.ssafy.io`
    * Path: `/api/posts` (서버 설정에 따른 경로 중복 확인 필수)

### 📊 분석 도구
* **Listeners**: Summary Report, View Results Tree
* **Plugins**: 3 Basic Graphs (TPS, Response Times Over Time, Active Threads)
* **Reporting**: JMeter HTML Dashboard Report

---

## 3. 테스트 결과 및 지표 분석

### 🚀 주요 성능 지표 (Statistics)
| 지표 | 결과값 | 의미 |
| :--- | :--- | :--- |
| **Total Samples** | 82,858건 | 테스트 동안 전송된 총 요청 수 |
| **Throughput (TPS)** | 2,235.54/sec | 초당 평균 처리량 |
| **Average Latency** | 1,163.31ms | 평균 응답 시간 (약 1.1초) |
| **99th Percentile** | **19,287.00ms** | 상위 1% 유저가 겪은 지연 시간 (**약 19초**) |
| **Error %** | **18.83%** | 부하를 견디지 못해 실패한 요청 비율 |
| **APDEX** | 0.373 | 사용자 만족도 (0에 가까울수록 매우 불만족) |



### ❌ 주요 에러 유형
* **Connection reset (35.13%)**: 서버 리소스 한계로 연결 강제 종료
* **Failed to respond (34.11%)**: 서버가 요청을 받았으나 응답 전송 실패
* **Socket closed (19.22%)**: 네트워크 소켓 고갈

---

## 4. 최종 결론 및 회고
1. **서버 한계 확인**: 동시 접속자 1,000명까지는 안정적이나, **3,000명 유입 시 서버가 비명을 지르며 5명 중 1명에게 에러를 뱉음.**
2. **병목 현상 발견**: 시간이 지남에 따라 대기열이 쌓여 응답 시간이 19초까지 늘어지는 전형적인 **병목(Bottleneck)** 현상 확인.
3. **학습 포인트**:
    * JMeter 설정 시 Protocol과 Server Name 칸을 엄격히 구분해야 통신 에러가 나지 않음.
    * 시각화 리포트(HTML Dashboard)는 단순 수치보다 훨씬 강력한 설득력을 가짐.
    * 부하 테스트는 단순히 '성공'을 보는 게 아니라, '어디서 무너지는지'를 찾는 과정임을 체득.