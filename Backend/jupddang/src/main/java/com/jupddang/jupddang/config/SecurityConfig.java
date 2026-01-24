package com.jupddang.jupddang.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                // JWT 사용으로 CSRF 보호 비활성화
                .csrf(AbstractHttpConfigurer::disable)
                // 요청 URL별 접근 권한 설정
                .authorizeHttpRequests(auth -> auth
                        // 회원가입, 로그인 API는 인증 없이 접근 허용
                        .requestMatchers("/api/account/signup", "/api/account/login")
                        .permitAll()
                        // 그 외 모든 요청은 인증된 사용자만 접근 가능
                        .anyRequest().authenticated() // 그 외 요청은 인증 필요
                )
                .build();
    }

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
