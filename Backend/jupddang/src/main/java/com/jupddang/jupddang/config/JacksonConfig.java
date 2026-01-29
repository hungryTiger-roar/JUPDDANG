package com.jupddang.jupddang.config;

import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateDeserializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.format.DateTimeFormatter;
import java.util.TimeZone;

/**
 * Jackson 전역 설정: ISO 8601 시간 포맷 표준화
 * 
 * <p>
 * 모든 LocalDateTime 및 LocalDate 필드를 ISO 8601 형식으로 직렬화/역직렬화합니다.
 * 이를 통해 Flutter 프론트엔드와의 호환성을 보장합니다.
 * </p>
 * 
 * <ul>
 * <li>LocalDateTime: "yyyy-MM-dd'T'HH:mm:ss" (예: "2026-01-29T12:25:00")</li>
 * <li>LocalDate: "yyyy-MM-dd" (예: "2026-01-29")</li>
 * <li>Timezone: Asia/Seoul (application.properties에서 설정)</li>
 * </ul>
 * 
 * @see <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO 8601 Standard</a>
 */
@Configuration
public class JacksonConfig {

    /**
     * Jackson ObjectMapper 커스터마이징
     * 
     * <p>
     * 이 설정은 모든 DTO에 자동으로 적용되므로, 개별 필드에 @JsonFormat 어노테이션을
     * 추가할 필요가 없습니다.
     * </p>
     * 
     * @return Jackson2ObjectMapperBuilderCustomizer
     */
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jsonCustomizer() {
        return builder -> {
            // ISO 8601 format for LocalDateTime: "yyyy-MM-dd'T'HH:mm:ss"
            // 밀리초를 제외하여 Flutter DateTime.tryParse()와 호환
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
            builder.serializers(new LocalDateTimeSerializer(dateTimeFormatter));
            builder.deserializers(new LocalDateTimeDeserializer(dateTimeFormatter));

            // ISO 8601 format for LocalDate: "yyyy-MM-dd"
            DateTimeFormatter dateFormatter = DateTimeFormatter.ISO_LOCAL_DATE;
            builder.serializers(new LocalDateSerializer(dateFormatter));
            builder.deserializers(new LocalDateDeserializer(dateFormatter));

            // Timezone 설정 (application.properties의 spring.jackson.time-zone과 동일)
            builder.timeZone(TimeZone.getTimeZone("Asia/Seoul"));
        };
    }
}
