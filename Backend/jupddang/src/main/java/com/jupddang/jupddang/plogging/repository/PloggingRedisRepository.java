package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Repository
public class PloggingRedisRepository {

    private final RedisTemplate<String, Object> redisTemplate;

    public PloggingRedisRepository(@Qualifier("redisTemplate") RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    // Redis Key Prefix
    private static final String KEY_STATUS = "plogging:status:";
    private static final String KEY_CAPTURED = "plogging:captured:";

    // TTL 설정
    private static final Duration TTL = Duration.ofHours(6);

    /**
     * 사용자 플로깅 상태 업데이트
     * DTO 통째로 업데이트 (거리, 위치 등 포함)
     */
    public void updateUserState(String userId, UserPloggingStatus status) {
        String key = KEY_STATUS + userId;

        try {
            redisTemplate.opsForHash().putAll(key, Map.of(
                    "h3", status.h3Index(),
                    "entryTime", String.valueOf(status.entryTime()),
                    "isOccupied", String.valueOf(status.isOccupied()),
                    "lastLat", String.valueOf(status.lastLat()),
                    "lastLon", String.valueOf(status.lastLon()),
                    "totalDistance", String.valueOf(status.totalDistance())));
            redisTemplate.expire(key, TTL);

            // log.debug("Redis 상태 업데이트: userId={}, h3={}, dist={}", userId,
            // status.h3Index(), status.totalDistance());
        } catch (Exception e) {
            log.error("Redis 상태 업데이트 실패: userId={}", userId, e);
            throw e;
        }
    }

    /**
     * 사용자 플로깅 상태 조회
     */
    public UserPloggingStatus getUserState(String userId) {
        String key = KEY_STATUS + userId;

        try {
            Map<Object, Object> entries = redisTemplate.opsForHash().entries(key);

            if (entries == null || entries.isEmpty()) {
                return null;
            }

            String h3 = (String) entries.get("h3");
            String entryTimeStr = (String) entries.get("entryTime");
            String isOccupiedStr = (String) entries.getOrDefault("isOccupied", "false");
            String lastLatStr = (String) entries.getOrDefault("lastLat", "0.0");
            String lastLonStr = (String) entries.getOrDefault("lastLon", "0.0");
            String totalDistStr = (String) entries.getOrDefault("totalDistance", "0.0");

            if (h3 == null || entryTimeStr == null) {
                return null;
            }

            return new UserPloggingStatus(
                    h3,
                    Double.parseDouble(lastLatStr),
                    Double.parseDouble(lastLonStr),
                    Double.parseDouble(totalDistStr),
                    Long.parseLong(entryTimeStr),
                    Boolean.parseBoolean(isOccupiedStr));

        } catch (Exception e) {
            log.error("Redis 상태 조회 실패: userId={}", userId, e);
            return null;
        }
    }

    public void deleteUserState(String userId) {
        String statusKey = KEY_STATUS + userId;
        String capturedKey = KEY_CAPTURED + userId;
        try {
            redisTemplate.delete(statusKey);
            redisTemplate.delete(capturedKey);
        } catch (Exception e) {
            log.error("Redis 데이터 삭제 실패: userId={}", userId, e);
            throw e;
        }
    }

    public boolean existsUserData(String userId) {
        try {
            Boolean statusExists = redisTemplate.hasKey(KEY_STATUS + userId);
            Boolean capturedExists = redisTemplate.hasKey(KEY_CAPTURED + userId);
            return Boolean.TRUE.equals(statusExists) || Boolean.TRUE.equals(capturedExists);
        } catch (Exception e) {
            return false;
        }
    }

    public void addCapturedGrid(String userId, String h3Index) {
        String key = KEY_CAPTURED + userId;
        try {
            redisTemplate.opsForSet().add(key, h3Index);
            redisTemplate.expire(key, TTL);
        } catch (Exception e) {
            log.error("Redis 점령 추가 실패: userId={}, h3={}", userId, h3Index, e);
            throw e;
        }
    }

    public Set<String> getCapturedGrids(String userId) {
        String key = KEY_CAPTURED + userId;
        try {
            Set<Object> members = redisTemplate.opsForSet().members(key);
            if (members == null || members.isEmpty()) {
                return Collections.emptySet();
            }
            return members.stream()
                    .map(obj -> {
                        String s = obj.toString();
                        return s.startsWith("\"") && s.endsWith("\"") ? s.substring(1, s.length() - 1) : s;
                    })
                    .collect(Collectors.toSet());
        } catch (Exception e) {
            return Collections.emptySet();
        }
    }

    public int getCapturedCount(String userId) {
        String key = KEY_CAPTURED + userId;
        try {
            Long size = redisTemplate.opsForSet().size(key);
            return size != null ? size.intValue() : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    public void removeCapturedGrid(String userId, String h3Index) {
        String key = KEY_CAPTURED + userId;
        try {
            redisTemplate.opsForSet().remove(key, h3Index);
        } catch (Exception e) {
            log.error("Redis 점령 제거 실패: userId={}, h3={}", userId, h3Index, e);
        }
    }
}
