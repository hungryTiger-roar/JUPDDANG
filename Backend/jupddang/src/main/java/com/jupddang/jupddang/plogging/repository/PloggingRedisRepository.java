package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Repository
@RequiredArgsConstructor
public class PloggingRedisRepository {

    private final RedisTemplate<String, Object> redisTemplate;

    private static final String KEY_STATUS = "plogging:status:";
    private static final String KEY_CAPTURED = "plogging:captured:"; // 점령 성공한 곳들

    public void updateUserState(String userId, String h3Index, long currentTime, boolean isOccupied) {
        String key = KEY_STATUS + userId;
        redisTemplate.opsForHash().putAll(key, Map.of(
                "h3", h3Index,
                "entryTime", String.valueOf(currentTime),
                "isOccupied", String.valueOf(isOccupied)
        ));
        redisTemplate.expire(key, Duration.ofHours(6));
    }

    public UserPloggingStatus getUserState(String userId) {
        String key = KEY_STATUS + userId;
        Map<Object, Object> entries = redisTemplate.opsForHash().entries(key);
        if (entries.isEmpty()) return null;

        return new UserPloggingStatus(
                (String) entries.get("h3"),
                Long.parseLong((String) entries.get("entryTime")),
                Boolean.parseBoolean((String) entries.getOrDefault("isOccupied", "false"))
        );
    }

    // --- 2. 점령(Capture) 목록 관리 ---

    // 점령 성공 시 추가 (기존 유지)
    public void addCapturedGrid(String userId, String h3Index) {
        String key = KEY_CAPTURED + userId;
        redisTemplate.opsForSet().add(key, h3Index);
        redisTemplate.expire(key, Duration.ofHours(6));
    }

    // 점령 개수 조회 (기존 유지)
    public int getCapturedCount(String userId) {
        String key = KEY_CAPTURED + userId;
        Long size = redisTemplate.opsForSet().size(key);
        return size != null ? size.intValue() : 0;
    }

    public Set<String> getCapturedGrids(String userId) {
        String key = KEY_CAPTURED + userId;
        Set<String> members = redisTemplate.opsForSet().members(key);
        return members != null ? members : Collections.emptySet();
    }

    public void deleteUserState(String userId) {
        redisTemplate.delete(KEY_STATUS + userId);
        redisTemplate.delete(KEY_CAPTURED + userId);

    // [수정] Long userId -> String userId
    public UserPloggingStatus getUserState(String userId) {
        // Redis Key 생성 시 String 결합
        return (UserPloggingStatus) redisTemplate.opsForValue().get("plogging:state:" + userId);
    }

    // [수정] Long userId -> String userId
    public void updateUserState(String userId, String h3Index, long entryTime, boolean isOccupied) {
        UserPloggingStatus status = new UserPloggingStatus(h3Index, entryTime, isOccupied);
        redisTemplate.opsForValue().set("plogging:state:" + userId, status, 30, TimeUnit.MINUTES);
    }

    // [수정] Long userId -> String userId
    public void addCapturedGrid(String userId, String h3Index) {
        redisTemplate.opsForSet().add("plogging:captured:" + userId, h3Index);
        redisTemplate.expire("plogging:captured:" + userId, 30, TimeUnit.MINUTES);
    }

    // [수정] Long userId -> String userId
    public int getCapturedCount(String userId) {
        Long size = redisTemplate.opsForSet().size("plogging:captured:" + userId);
        return size != null ? size.intValue() : 0;
    }

    // [수정] Long userId -> String userId
    public void deleteUserState(String userId) {
        redisTemplate.delete("plogging:state:" + userId);
        redisTemplate.delete("plogging:captured:" + userId);
    }
}