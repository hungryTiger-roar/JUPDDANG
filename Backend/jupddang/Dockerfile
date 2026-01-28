# ========================================================
# 1. Build Stage (빌드 환경)
# ========================================================
# [수정] openjdk -> eclipse-temurin (Java 21 공식 권장 이미지)
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

# 1-1. Gradle 빌드에 필요한 파일만 먼저 복사 (캐시 활용)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 1-2. gradlew 실행 권한 부여
RUN chmod +x ./gradlew

# 1-3. 의존성 다운로드 (소스코드 복사 전에 수행하여 빌드 속도 향상)
RUN ./gradlew dependencies --no-daemon

# 1-4. 소스 코드 복사 및 빌드 수행
COPY src src
# 테스트 제외(-x test)하고 빌드하여 속도 향상
RUN ./gradlew clean build -x test --no-daemon

# ========================================================
# 2. Run Stage (실행 환경)
# ========================================================
# [수정] 실행 환경도 동일한 베이스 이미지 사용
FROM eclipse-temurin:21-jdk
WORKDIR /app

# 2-1. 빌드 스테이지에서 생성된 JAR 파일만 가져옴
COPY --from=builder /app/build/libs/*.jar app.jar

# 2-2. 실행 설정
ENV TZ=Asia/Seoul
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-Duser.timezone=Asia/Seoul", "-jar", "app.jar"]