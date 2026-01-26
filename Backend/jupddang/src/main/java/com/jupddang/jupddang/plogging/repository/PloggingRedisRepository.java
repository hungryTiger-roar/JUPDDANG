package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
@RequiredArgsConstructor
public class PloggingRedisRepository {

    private final StringRedisTemplate redisTemplate;
    private static final String KEY_PREFIX = "plogging:status:";

    // 위치 갱신 (Key: plogging:status:{userId})
    public void updateUserState(Long userId, String h3Index, long currentTime) {
        String key = KEY_PREFIX + userId;
        // 해시(Hash) 구조로 저장: { "h3": "...", "entryTime": "..." }
        redisTemplate.opsForHash().putAll(key, Map.of(
                "h3", h3Index,
                "entryTime", String.valueOf(currentTime)
        ));
    }

    // 상태 조회
    public UserPloggingStatus getUserState(Long userId) {
        String key = KEY_PREFIX + userId;
        Map<Object, Object> entries = redisTemplate.opsForHash().entries(key);

        if (entries.isEmpty()) return null;

        return new UserPloggingStatus(
                (String) entries.get("h3"),
                Long.parseLong((String) entries.get("entryTime"))
        );
    }

    // 상태 삭제 (종료 시 호출)
    public void deleteUserState(Long userId) {
        redisTemplate.delete(KEY_PREFIX + userId);
    }
}