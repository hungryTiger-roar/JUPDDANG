package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Repository
@RequiredArgsConstructor
public class PloggingRedisRepository {

    private final RedisTemplate<String, Object> redisTemplate;

    // Redis Key Prefix
    private static final String KEY_STATUS = "plogging:status:";
    private static final String KEY_CAPTURED = "plogging:captured:";

    // TTL 설정
    private static final Duration TTL = Duration.ofHours(6);

    // =========================================================================
    // 플로깅 상태 관리
    // =========================================================================

    /**
     * 사용자 플로깅 상태 업데이트
     * 
     * @param userId     사용자 ID (String)
     * @param h3Index    현재 H3 그리드 인덱스
     * @param entryTime  진입 시간 (밀리초)
     * @param isOccupied 점령 완료 여부
     */
    public void updateUserState(String userId, String h3Index, long entryTime, boolean isOccupied) {
        String key = KEY_STATUS + userId;

        try {
            redisTemplate.opsForHash().putAll(key, Map.of(
                    "h3", h3Index,
                    "entryTime", String.valueOf(entryTime),
                    "isOccupied", String.valueOf(isOccupied)));
            redisTemplate.expire(key, TTL);

            log.debug("Redis 상태 업데이트: userId={}, h3={}, occupied={}", userId, h3Index, isOccupied);
        } catch (Exception e) {
            log.error("Redis 상태 업데이트 실패: userId={}", userId, e);
            throw e;
        }
    }

    /**
     * 사용자 플로깅 상태 조회
     * 
     * @param userId 사용자 ID (String)
     * @return UserPloggingStatus 또는 null
     */
    public UserPloggingStatus getUserState(String userId) {
        String key = KEY_STATUS + userId;

        try {
            Map<Object, Object> entries = redisTemplate.opsForHash().entries(key);

            if (entries == null || entries.isEmpty()) {
                log.debug("Redis 상태 없음: userId={}", userId);
                return null;
            }

            String h3 = (String) entries.get("h3");
            String entryTimeStr = (String) entries.get("entryTime");
            String isOccupiedStr = (String) entries.getOrDefault("isOccupied", "false");

            if (h3 == null || entryTimeStr == null) {
                log.warn("Redis 데이터 불완전: userId={}", userId);
                return null;
            }

            long entryTime = Long.parseLong(entryTimeStr);
            boolean isOccupied = Boolean.parseBoolean(isOccupiedStr);

            return new UserPloggingStatus(h3, entryTime, isOccupied);

        } catch (Exception e) {
            log.error("Redis 상태 조회 실패: userId={}", userId, e);
            return null;
        }
    }

    /**
     * 사용자 플로깅 데이터 전체 삭제
     * 
     * @param userId 사용자 ID (String)
     */
    public void deleteUserState(String userId) {
        String statusKey = KEY_STATUS + userId;
        String capturedKey = KEY_CAPTURED + userId;

        try {
            Boolean statusDeleted = redisTemplate.delete(statusKey);
            Boolean capturedDeleted = redisTemplate.delete(capturedKey);

            log.info("Redis 데이터 삭제: userId={}, status={}, captured={}",
                    userId, statusDeleted, capturedDeleted);

        } catch (Exception e) {
            log.error("Redis 데이터 삭제 실패: userId={}", userId, e);
            throw e;
        }
    }

    /**
     * 사용자의 모든 Redis 키 존재 여부 확인
     * 
     * @param userId 사용자 ID (String)
     * @return 데이터 존재 여부
     */
    public boolean existsUserData(String userId) {
        try {
            Boolean statusExists = redisTemplate.hasKey(KEY_STATUS + userId);
            Boolean capturedExists = redisTemplate.hasKey(KEY_CAPTURED + userId);

            return Boolean.TRUE.equals(statusExists) || Boolean.TRUE.equals(capturedExists);
        } catch (Exception e) {
            log.error("Redis 존재 확인 실패: userId={}", userId, e);
            return false;
        }
    }

    // =========================================================================
    // 점령 그리드 관리
    // =========================================================================

    /**
     * 점령 성공한 그리드 추가
     * 
     * @param userId  사용자 ID (String)
     * @param h3Index 점령한 H3 그리드 인덱스
     */
    public void addCapturedGrid(String userId, String h3Index) {
        String key = KEY_CAPTURED + userId;

        try {
            redisTemplate.opsForSet().add(key, h3Index);
            redisTemplate.expire(key, TTL);

            log.debug("Redis 점령 추가: userId={}, h3={}", userId, h3Index);
        } catch (Exception e) {
            log.error("Redis 점령 추가 실패: userId={}, h3={}", userId, h3Index, e);
            throw e;
        }
    }

    /**
     * 점령한 그리드 목록 조회
     * 
     * @param userId 사용자 ID (String)
     * @return 점령한 H3 인덱스 Set (빈 Set 반환 가능)
     */
    public Set<String> getCapturedGrids(String userId) {
        String key = KEY_CAPTURED + userId;

        try {
            Set<Object> members = redisTemplate.opsForSet().members(key);

            if (members == null || members.isEmpty()) {
                log.debug("Redis 점령 목록 없음: userId={}", userId);
                return Collections.emptySet();
            }

            return members.stream()
                    .map(obj -> {
                        // JSON 직렬화로 인해 따옴표가 붙어나오는 경우 처리
                        String s = obj.toString();
                        return s.startsWith("\"") && s.endsWith("\"") ? s.substring(1, s.length() - 1) : s;
                    })
                    .collect(Collectors.toSet());

        } catch (Exception e) {
            log.error("Redis 점령 목록 조회 실패: userId={}", userId, e);
            return Collections.emptySet();
        }
    }

    /**
     * 점령한 그리드 개수 조회
     * 
     * @param userId 사용자 ID (String)
     * @return 점령한 그리드 개수
     */
    public int getCapturedCount(String userId) {
        String key = KEY_CAPTURED + userId;

        try {
            Long size = redisTemplate.opsForSet().size(key);
            int count = size != null ? size.intValue() : 0;

            log.debug("Redis 점령 개수: userId={}, count={}", userId, count);
            return count;

        } catch (Exception e) {
            log.error("Redis 점령 개수 조회 실패: userId={}", userId, e);
            return 0;
        }
    }

    /**
     * 특정 그리드를 점령 목록에서 제거
     * 
     * @param userId  사용자 ID (String)
     * @param h3Index 제거할 H3 그리드 인덱스
     */
    public void removeCapturedGrid(String userId, String h3Index) {
        String key = KEY_CAPTURED + userId;

        try {
            Long removed = redisTemplate.opsForSet().remove(key, h3Index);
            log.debug("Redis 점령 제거: userId={}, h3={}, removed={}", userId, h3Index, removed);
        } catch (Exception e) {
            log.error("Redis 점령 제거 실패: userId={}, h3={}", userId, h3Index, e);
        }
    }
}
