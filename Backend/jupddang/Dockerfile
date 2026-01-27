# 1. Build Stage
FROM eclipse-temurin:21-jdk-alpine as builder
WORKDIR /build

# [필수] 윈도우 -> 리눅스 파일 변환 도구 설치
RUN apk update && apk add --no-cache dos2unix

# Wrapper 및 설정 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle .

# [핵심 해결책] 
# 1. gradlew 파일의 줄바꿈을 리눅스용(LF)으로 강제 변환
# 2. 실행 권한 부여
RUN dos2unix gradlew && chmod +x gradlew

# 의존성 다운로드 (로그 레벨 높임)
RUN ./gradlew dependencies --no-daemon --info

# 소스 복사
COPY src ./src

# [핵심 해결책] 빌드 실행 시 상세 로그 출력 (--info --stacktrace)
# 이걸 넣어야 왜 롬복이 적용 안 되는지 '진짜 에러'가 나옵니다.
RUN ./gradlew build -x test --no-daemon --info --stacktrace

# 2. Run Stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
ENV TZ=Asia/Seoul
RUN apk add --no-cache tzdata
COPY --from=builder /build/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-jar", "/app/app.jar"]