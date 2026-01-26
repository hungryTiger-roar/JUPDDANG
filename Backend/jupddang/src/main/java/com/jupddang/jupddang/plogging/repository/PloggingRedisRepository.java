package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class PloggingRedisRepository {

    private final StringRedisTemplate redisTemplate;

    private static final String KEY_STATUS = "plogging:status:";
    private static final String KEY_CAPTURED = "plogging:captured:";

    // [중요] Service에서 호출하는 시그니처와 일치해야 함
    public void updateUserState(Long userId, String h3Index, long currentTime, boolean isOccupied) {
        String key = KEY_STATUS + userId;
        redisTemplate.opsForHash().putAll(key, Map.of(
                "h3", h3Index,
                "entryTime", String.valueOf(currentTime),
                "isOccupied", String.valueOf(isOccupied)
        ));
        redisTemplate.expire(key, Duration.ofHours(6));
    }

    public UserPloggingStatus getUserState(Long userId) {
        String key = KEY_STATUS + userId;
        Map<Object, Object> entries = redisTemplate.opsForHash().entries(key);
        if (entries.isEmpty()) return null;

        return new UserPloggingStatus(
                (String) entries.get("h3"),
                Long.parseLong((String) entries.get("entryTime")),
                Boolean.parseBoolean((String) entries.getOrDefault("isOccupied", "false"))
        );
    }

    // Account 점수용: 점령한 땅 추가
    public void addCapturedGrid(Long userId, String h3Index) {
        String key = KEY_CAPTURED + userId;
        redisTemplate.opsForSet().add(key, h3Index);
        redisTemplate.expire(key, Duration.ofHours(6));
    }

    // Account 점수용: 점령 개수 조회
    public int getCapturedCount(Long userId) {
        String key = KEY_CAPTURED + userId;
        Long size = redisTemplate.opsForSet().size(key);
        return size != null ? size.intValue() : 0;
    }

    public void deleteUserState(Long userId) {
        redisTemplate.delete(KEY_STATUS + userId);
        redisTemplate.delete(KEY_CAPTURED + userId);
    }
}