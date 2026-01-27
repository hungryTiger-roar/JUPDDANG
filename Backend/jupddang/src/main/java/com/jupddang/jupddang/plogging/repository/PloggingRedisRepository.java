package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.concurrent.TimeUnit;

@Repository
@RequiredArgsConstructor
public class PloggingRedisRepository {

    private final RedisTemplate<String, Object> redisTemplate;

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