# ==========================================
# 1. Build Stage
# ==========================================
# Gradle 이미지가 아니라, 그냥 JDK 이미지를 씁니다. (Wrapper가 알아서 Gradle을 설치하니까요)
FROM eclipse-temurin:21-jdk-alpine as builder
WORKDIR /build

# [필수] Wrapper와 설정 파일들 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle .

# [중요] gradlew 실행 권한 부여
RUN chmod +x ./gradlew

# [최적화] 소스코드 없이 의존성만 먼저 다운로드 (Lombok 포함)
# --no-daemon: CI 환경에서는 데몬을 안 쓰는 게 안정적입니다.
RUN ./gradlew dependencies --no-daemon

# 소스코드 복사 및 빌드
COPY src ./src
# -x test: 테스트 제외 (필요 시 제거)
RUN ./gradlew build -x test --no-daemon

# ==========================================
# 2. Run Stage (기존과 동일)
# ==========================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
ENV TZ=Asia/Seoul

RUN apk add --no-cache tzdata

COPY --from=builder /build/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-jar", "/app/app.jar"]