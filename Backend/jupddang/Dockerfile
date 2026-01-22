# ==========================================
# 1. Build Stage (Gradle + JDK 21)
# ==========================================
FROM gradle:8.5-jdk21-alpine as builder
WORKDIR /build

# [최적화 핵심] 라이브러리 설치 레이어 분리
# 소스코드(src)보다 설정파일을 먼저 복사
COPY build.gradle settings.gradle ./

# 소스코드 없이 라이브러리만 먼저 다운로드 (캐싱)
# --no-daemon: CI 환경에서 데몬 프로세스 방지
RUN gradle dependencies --no-daemon || true

# 실제 소스코드 복사 및 빌드
COPY src ./src
# -x test: 테스트는 CI 파이프라인(GitLab) 단계에서 수행하거나 생략하여 빌드 속도 향상
RUN gradle build -x test --no-daemon

# ==========================================
# 2. Run Stage (JDK 21 Lightweight)
# ==========================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# 빌드 결과물 복사
COPY --from=builder /build/build/libs/*.jar app.jar

# 타임존 설정 (KST)
ENV TZ=Asia/Seoul
RUN apk add --no-cache tzdata

# 실행 (운영 프로파일 적용)
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]