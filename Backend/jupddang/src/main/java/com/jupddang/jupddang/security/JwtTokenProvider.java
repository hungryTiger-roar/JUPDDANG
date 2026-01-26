package com.jupddang.jupddang.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.WeakKeyException;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.JwtException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;
import java.util.List;

@Component
public class JwtTokenProvider {

    private final SecretKey key;
    private final Duration accessTokenValidity;
    private final String issuer;
    private final UserDetailsService userDetailsService;

    public JwtTokenProvider(
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.access-exp-min}") long accessTokenExpMin,
            @Value("${jwt.issuer}") String issuer,
            UserDetailsService userDetailsService
    ) {
        this.key = createKey(secret);
        this.accessTokenValidity = Duration.ofMinutes(accessTokenExpMin);
        this.issuer = issuer;
        this.userDetailsService = userDetailsService;
    }

    /**
     * Access Token 생성
     *
     * @param userId 사용자 ID
     * @param roles 사용자 권한 목록
     * @return JWT Access Token 문자열
     */
    public String createAccessToken(String userId, List<String> roles) {
        Instant now = Instant.now();
        Instant expiry = now.plus(accessTokenValidity);
        return Jwts.builder()
                .setSubject(userId)
                .setIssuer(issuer)
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(expiry))
                .claim("roles", roles)
                .signWith(key)
                .compact();
    }

    /**
     * Access Token 만료 시간(초) 반환
     */
    public long getAccessTokenExpiresInSeconds() {
        return accessTokenValidity.toSeconds();
    }


    public Authentication getAuthentication(String token) {
        // 1. 토큰에서 Claims(payload) 추출
        Claims claims = parseClaims(token);
        String userId = claims.getSubject();

        // 2. UserDetailsService를 통해 DB에서 Account 엔티티 조회
        // loadUserByUsername()이 Account를 반환하므로 UserDetails = Account
        UserDetails account = userDetailsService.loadUserByUsername(userId);

        // 3. Authentication 객체 생성
        // Principal에 Account 엔티티 전체를 저장 (userId가 아닌 account 객체)
        return new UsernamePasswordAuthenticationToken(
                account,  // Principal = Account 엔티티 (이전: userId String)
                null,     // Credentials (비밀번호는 불필요)
                account.getAuthorities()  // 권한 정보
        );
    }

    /**
     * JWT 토큰 유효성 검증
     *
     * @param token JWT 토큰
     * @return 유효하면 true, 그렇지 않으면 false
     */
    public boolean validateToken(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * JWT 토큰 파싱 및 Claims 추출
     *
     * @param token JWT 토큰
     * @return Claims 객체
     * @throws JwtException 토큰이 유효하지 않은 경우
     */
    private Claims parseClaims(String token) {
        Jws<Claims> jws = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token);
        return jws.getBody();
    }

    /**
     * Secret Key 생성
     * Base64 디코딩 시도 후 실패하면 UTF-8 바이트로 처리
     *
     * @param secret Secret 문자열
     * @return SecretKey 객체
     */
    private SecretKey createKey(String secret) {
        try {
            byte[] decoded = Decoders.BASE64.decode(secret);
            return Keys.hmacShaKeyFor(decoded);
        } catch (IllegalArgumentException ex) {
            byte[] raw = secret.getBytes(StandardCharsets.UTF_8);
            try {
                return Keys.hmacShaKeyFor(raw);
            } catch (WeakKeyException weakKeyException) {
                throw new IllegalStateException("JWT secret is too short. Use at least 32 bytes.", weakKeyException);
            }
        }
    }
}