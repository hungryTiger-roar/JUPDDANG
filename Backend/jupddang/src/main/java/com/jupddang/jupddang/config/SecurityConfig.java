package com.jupddang.jupddang.config;

import org.springframework.http.HttpMethod;
import com.jupddang.jupddang.security.JwtAuthenticationFilter;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

        private final JwtTokenProvider jwtTokenProvider;
        private final AuthenticationEntryPoint authenticationEntryPoint;

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                return http
                                // JWT 기반이므로 불필요한 설정 비활성화
                                .csrf(AbstractHttpConfigurer::disable)
                                .httpBasic(AbstractHttpConfigurer::disable)
                                .formLogin(AbstractHttpConfigurer::disable)
                                .cors(cors -> cors.configure(http)) // Nginx 환경에서 CORS 문제 방지
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                                // 예외 처리 (인증 실패 시)
                                .exceptionHandling(ex -> ex.authenticationEntryPoint(authenticationEntryPoint))

                                // =====================================================================
                                // 🚧 [개발용] 전체 허용 설정
                                // 현재 상태: 개발 편의를 위해 모든 요청(Actuator 포함)을 허용합니다.
                                // =====================================================================
                                .authorizeHttpRequests(auth -> auth.anyRequest().permitAll())

                                // =====================================================================
                                // 🔒 [배포용] 실제 보안 설정 (현재 주석 처리됨)
                                // 배포 시 위 [개발용] 코드를 지우고, 아래 주석(/* ... */)을 해제하여 사용하세요.
                                // =====================================================================
                                /*
                                 * .authorizeHttpRequests(auth -> auth
                                 * // 1. Swagger 관련 모든 경로 허용 (UI, Docs, Resources)
                                 * .requestMatchers(
                                 * "/swagger-ui/**",
                                 * "/v3/api-docs/**",
                                 * "/swagger-resources/**",
                                 * "/webjars/**"
                                 * ).permitAll()
                                 * 
                                 * // 2. 모니터링(Actuator) 및 헬스체크 허용 [중요: Prometheus 수집을 위해 필수]
                                 * .requestMatchers("/actuator/**").permitAll()
                                 * 
                                 * // 3. 회원가입/로그인 및 에러 페이지 허용
                                 * .requestMatchers(
                                 * "/api/account/signup",
                                 * "/api/account/login",
                                 * "/api/auth/**",
                                 * "/error"
                                 * ).permitAll()
                                 * 
                                 * // 4. 쓰레기통 조회 허용 (공개 API)
                                 * .requestMatchers(HttpMethod.GET, "/api/v1/trashcans/**").permitAll()
                                 * 
                                 * // 5. 그 외 모든 요청은 인증 필요
                                 * .anyRequest().authenticated()
                                 * )
                                 */
                                // =====================================================================

                                .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider),
                                                UsernamePasswordAuthenticationFilter.class)
                                .build();
        }

        @Bean
        public BCryptPasswordEncoder bCryptPasswordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
                return authConfig.getAuthenticationManager();
        }
}