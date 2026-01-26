# ==========================================
# 1. Build Stage (Gradle + JDK 21)
# ==========================================
FROM gradle:8.5-jdk21-alpine as builder
WORKDIR /build

# [추가] 빌드 환경에서도 한글 파일명이나 주석 처리를 위해 UTF-8 강제
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# [최적화 핵심] 라이브러리 설치 레이어 분리
COPY build.gradle settings.gradle ./

# 소스코드 없이 라이브러리만 먼저 다운로드 (캐싱)
RUN gradle dependencies --no-daemon || true

# 실제 소스코드 복사 및 빌드
COPY src ./src
# -x test: 테스트는 CI 파이프라인 단계에서 수행
RUN gradle build -x test --no-daemon

# ==========================================
# 2. Run Stage (JDK 21 Lightweight)
# ==========================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# [핵심 해결책 1] OS 레벨 인코딩 설정 (Alpine Linux 필수)
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# [선택] 만약 이미지 처리나 폰트 관련 기능(엑셀/PDF 등)이 있다면 아래 주석 해제
# RUN apk add --no-cache fontconfig ttf-dejavu

# 빌드 결과물 복사
COPY --from=builder /build/build/libs/*.jar app.jar

# 타임존 설정 (KST)
ENV TZ=Asia/Seoul
RUN apk add --no-cache tzdata

# [핵심 해결책 2] JVM 실행 시 인코딩 강제 옵션 추가
# -Dfile.encoding=UTF-8 : 파일 입출력 시 UTF-8 사용
# -Dsun.jnu.encoding=UTF-8 : OS 파일 시스템 경로 해석 시 UTF-8 사용
ENTRYPOINT ["java", "-Dfile.encoding=UTF-8", "-Dsun.jnu.encoding=UTF-8", "-jar", "/app/app.jar"]