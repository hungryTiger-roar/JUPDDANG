package com.jupddang.jupddang.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * JWT 인증 필터
 *
 * 모든 HTTP 요청에 대해 JWT 토큰을 검증하고, 유효한 경우 사용자 인증 정보를 SecurityContext에 저장합니다.
 * OncePerRequestFilter를 상속받아 요청당 한 번만 실행되도록 보장합니다.
 *
 * 동작 순서:
 * 1. HTTP 요청 헤더에서 JWT 토큰 추출
 * 2. 토큰 유효성 검증
 * 3. 유효한 경우 Authentication 객체 생성 및 SecurityContext에 저장
 * 4. 다음 필터로 요청 전달
 */
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    // JWT 토큰 생성 및 검증을 담당하는 컴포넌트
    private final JwtTokenProvider jwtTokenProvider;

    /**
     * 생성자 - JwtTokenProvider 주입
     *
     * @param jwtTokenProvider JWT 토큰 처리를 위한 Provider
     */
    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    /**
     * 필터의 핵심 로직 - 모든 HTTP 요청마다 실행됩니다
     *
     * JWT 토큰을 검증하고 인증 정보를 SecurityContext에 설정합니다.
     * 인증에 실패하거나 토큰이 없어도 예외를 던지지 않고 다음 필터로 진행합니다.
     * (실제 접근 권한 체크는 SecurityConfig의 authorizeHttpRequests에서 수행)
     *
     * @param request  HTTP 요청 객체
     * @param response HTTP 응답 객체
     * @param filterChain 다음 필터를 실행하기 위한 체인
     * @throws ServletException 서블릿 예외
     * @throws IOException 입출력 예외
     */
    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        // 1. HTTP 요청 헤더에서 JWT 토큰 추출
        String token = resolveToken(request);

        // 2. 토큰이 존재하고 유효한 경우
        if (token != null && jwtTokenProvider.validateToken(token)) {
            // 3. 토큰에서 인증 정보(Authentication) 추출
            Authentication authentication = jwtTokenProvider.getAuthentication(token);

            // 4. SecurityContext에 인증 정보 저장
            // 이후 @AuthenticationPrincipal, SecurityContextHolder 등으로 사용자 정보 접근 가능
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        // 5. 다음 필터로 요청 전달 (필터 체인 계속 진행)
        // 토큰이 없거나 유효하지 않아도 여기까지 도달하며,
        // 실제 인증 필요 여부는 SecurityConfig의 설정에 따라 결정됨
        filterChain.doFilter(request, response);
    }

    /**
     * HTTP 요청 헤더에서 JWT 토큰을 추출합니다
     *
     * Authorization 헤더의 형식: "Bearer {JWT토큰}"
     * 예시: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
     *
     * @param request HTTP 요청 객체
     * @return 추출된 JWT 토큰 문자열, 토큰이 없거나 형식이 잘못된 경우 null 반환
     */
    private String resolveToken(HttpServletRequest request) {

        // 1. Authorization 헤더 값 가져오기
        String bearer = request.getHeader("Authorization");

        // 2. Authorization 헤더가 없거나 빈 값인 경우
        if (bearer == null || bearer.isBlank()) {
            return null;
        }

        // 3. "Bearer "로 시작하는 경우 (정상적인 JWT 형식)
        if (bearer.startsWith("Bearer ")) {
            // "Bearer " 이후의 실제 토큰 부분만 추출
            // substring(7): "Bearer " = 7글자를 제외한 나머지
            // trim(): 앞뒤 공백 제거
            return bearer.substring(7).trim();
        }

        // 4. "Bearer "로 시작하지 않는 경우 (잘못된 형식)
        return null;
    }
}