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

    /**
     * 사용자 플로깅 상태 업데이트
     * @param userId 사용자 ID (String)
     * @param h3Index 현재 H3 그리드 인덱스
     * @param entryTime 진입 시간 (밀리초)
     * @param isOccupied 점령 완료 여부
     */
    public void updateUserState(String userId, String h3Index, long entryTime, boolean isOccupied) {
        String key = KEY_STATUS + userId;

        try {
            redisTemplate.opsForHash().putAll(key, Map.of(
                    "h3", h3Index,
                    "entryTime", String.valueOf(entryTime),
                    "isOccupied", String.valueOf(isOccupied)
            ));
            redisTemplate.expire(key, TTL);

            log.debug("Redis 상태 업데이트: userId={}, h3={}, occupied={}", userId, h3Index, isOccupied);
        } catch (Exception e) {
            log.error("Redis 상태 업데이트 실패: userId={}", userId, e);
            throw e;
        }
    }

    /**
     * 사용자 플로깅 상태 조회
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
     * 점령 성공한 그리드 추가
     * @param userId 사용자 ID (String)
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

            // Object를 String으로 변환
            Set<String> result = members.stream()
                    .map(Object::toString)
                    .collect(java.util.stream.Collectors.toSet());

            log.debug("Redis 점령 목록 조회: userId={}, count={}", userId, result.size());
            return result;

        } catch (Exception e) {
            log.error("Redis 점령 목록 조회 실패: userId={}", userId, e);
            return Collections.emptySet();
        }
    }

    /**
     * 점령한 그리드 개수 조회
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
     * 사용자 플로깅 데이터 전체 삭제
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
     * 특정 그리드를 점령 목록에서 제거
     * @param userId 사용자 ID (String)
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

    /**
     * 사용자의 모든 Redis 키 존재 여부 확인
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

    // [랭킹]
    /**
     * 랭킹 점수 업데이트 (누적 & 월간 동시에 반영))
     * @param userId 사용자 ID
     * @param totalScore 현재 누적 총점 (Account.totalScore)
     * @param monthlyKey 이번 달 랭킹 키 (예: ranking:monthly:202601)
     * @param monthlyScore 이번 달 점수 합계
     */
    public void updateRankScore(String userId, long totalScore, String monthlyKey, long monthlyScore) {
        String totalKey = "ranking:total"; // 전체(누적) 랭킹 키

        try {
            // 전체 랭킹 : 누적 점수로 저장 (덮어쓰기)
            redisTemplate.opsForZSet().add(totalKey, userId, totalScore);

            // 월간 랭킹 : 해당 월 키에 점수 저장
            if (monthlyKey != null) {
                redisTemplate.opsForZSet().add(monthlyKey, userId, monthlyScore);
                // 월간 랭킹 키 40일 뒤 자동 삭제 (메모리 관리용)
                redisTemplate.expire(monthlyKey, Duration.ofDays(40));
            }

            log.debug("랭킹 업데이트 완료: User={}, Total={}, Monthly={}", userId, totalScore, monthlyScore);

        } catch (Exception e) {
            log.error("랭킹 점수 업데이트 실패: userId={}", userId, e);
        }
    }

    /**
     * 상위권(Top N) 조회
     * @param key 랭킹 키 (전체 or 월간)
     * @param limit 가져올 명수 (예: 3)
     */
    public Set<ZSetOperations.TypedTuple<Object>> getTopRankers(String key, int limit) {
        try {
            // 점수 높은 순으로 조회 ( 0등~(limit-1)등 => 1등~limit등)
            return redisTemplate.opsForZSet().reverseRangeWithScores(key, 0, limit -1);
        } catch (Exception e) {
            log.error("Top 랭커 조회 실패: key={}", key, e);
            return Collections.emptySet();
        }
    }

    /**
     * 내 등수 조회
     */
    public Long getMyRank(String key, String userId) {
        try{
            return redisTemplate.opsForZSet().reverseRank(key, userId);
        } catch (Exception e) {
            log.error("내 등수 조회 실패: key={}, userId={}", key, userId, e);
            return null;
        }
    }

    /**
     * 내 점수 조회
     */
    public Double getMyScore(String key, String userId) {
        try {
            return redisTemplate.opsForZSet().score(key, userId);
        } catch (Exception e) {
            log.error("내 점수 조회 실패: key={}, userId={}", key, userId, e);
            return null;
        }
    }

    /**
     * 특정 범위(Window) 조회 (Start등 ~ End등)
     * 내 등수 앞뒤 2명을 구할 때 사용
     */
    public Set<ZSetOperations.TypedTuple<Object>> getRankWindow(String key, long start, long end) {
        try {
            return redisTemplate.opsForZSet().reverseRangeWithScores(key, start, end);
        } catch (Exception e) {
            log.error("랭킹 윈도우 조회 실패: key={}", key, e);
            return Collections.emptySet();
        }
    }
}
