package com.jupddang.jupddang.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {

    /**
     * 플로깅 상태 관리용 RedisTemplate
     * - 복잡한 객체 저장 (Hash, Set)
     * - JSON 직렬화 사용
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(connectionFactory);

        // Key는 문자열로 저장
        redisTemplate.setKeySerializer(new StringRedisSerializer());

        // Value는 JSON으로 저장
        redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer());

        // Hash 자료구조를 쓸 때도 동일하게 설정
        redisTemplate.setHashKeySerializer(new StringRedisSerializer());
        redisTemplate.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());

        return redisTemplate;
    }

    /**
     * 랭킹 전용 RedisTemplate
     * - 단순 점수 저장 (Sorted Set)
     * - String 직렬화로 성능 최적화
     */
    @Bean
    public RedisTemplate<String, Object> rankingRedisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // Key와 Value 모두 String으로 직렬화
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new StringRedisSerializer());

        return template;
    }
}
