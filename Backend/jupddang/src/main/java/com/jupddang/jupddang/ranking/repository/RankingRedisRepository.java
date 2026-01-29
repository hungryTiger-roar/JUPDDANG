package com.jupddang.jupddang.ranking.repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.Collections;
import java.util.Set;

/**
 * 랭킹 전용 Redis Repository
 * - 랭킹 데이터 관리 (ranking:total, ranking:monthly:YYYYMM)
 * - rankingRedisTemplate 사용 (String 직렬화)
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class RankingRedisRepository {

    @Qualifier("rankingRedisTemplate")
    private final RedisTemplate<String, Object> rankingRedisTemplate;

    /**
     * 랭킹 점수 업데이트 (누적 & 월간 동시 반영)
     * 
     * @param userId       사용자 ID
     * @param totalScore   현재 누적 총점 (Account.totalScore)
     * @param monthlyKey   이번 달 랭킹 키 (예: ranking:monthly:202601)
     * @param monthlyScore 이번 달 점수 합계
     */
    public void updateRankScore(String userId, long totalScore, String monthlyKey, long monthlyScore) {
        String totalKey = "ranking:total";

        try {
            rankingRedisTemplate.opsForZSet().add(totalKey, userId, totalScore);

            if (monthlyKey != null) {
                rankingRedisTemplate.opsForZSet().add(monthlyKey, userId, monthlyScore);
                rankingRedisTemplate.expire(monthlyKey, Duration.ofDays(40));
            }

            log.debug("랭킹 업데이트 완료: User={}, Total={}, Monthly={}", userId, totalScore, monthlyScore);

        } catch (Exception e) {
            log.error("랭킹 점수 업데이트 실패: userId={}", userId, e);
        }
    }

    /**
     * ✅ [추가] 랭킹 점수 업데이트 (단순 버전 - 테스트용)
     * 
     * @param key    랭킹 키 (예: "ranking:total", "ranking:monthly:202601")
     * @param userId 사용자 ID
     * @param score  점수
     *
     *               사용처:
     *               - 통합 테스트에서 간단하게 랭킹 데이터 생성
     */
    public void updateRanking(String key, String userId, double score) {
        try {
            rankingRedisTemplate.opsForZSet().add(key, userId, score);
            log.debug("랭킹 단순 업데이트: key={}, userId={}, score={}", key, userId, score);
        } catch (Exception e) {
            log.error("랭킹 업데이트 실패: key={}, userId={}", key, userId, e);
            throw e;
        }
    }

    /**
     * 상위권(Top N) 조회
     * 
     * @param key   랭킹 키 (전체 or 월간)
     * @param limit 가져올 명수 (예: 3)
     * @return Top N 랭커 리스트 (점수 높은 순)
     */
    public Set<ZSetOperations.TypedTuple<Object>> getTopRankers(String key, int limit) {
        try {
            return rankingRedisTemplate.opsForZSet().reverseRangeWithScores(key, 0, limit - 1);
        } catch (Exception e) {
            log.error("Top 랭커 조회 실패: key={}", key, e);
            return Collections.emptySet();
        }
    }

    /**
     * 내 등수 조회 (0-based index, null이면 랭킹에 없음)
     * 
     * @param key    랭킹 키
     * @param userId 사용자 ID
     * @return 등수 (0부터 시작, null이면 랭킹 없음)
     */
    public Long getMyRank(String key, String userId) {
        try {
            return rankingRedisTemplate.opsForZSet().reverseRank(key, userId);
        } catch (Exception e) {
            log.error("내 등수 조회 실패: key={}, userId={}", key, userId, e);
            return null;
        }
    }

    /**
     * 내 점수 조회
     * 
     * @param key    랭킹 키
     * @param userId 사용자 ID
     * @return 점수 (없으면 null)
     */
    public Double getMyScore(String key, String userId) {
        try {
            return rankingRedisTemplate.opsForZSet().score(key, userId);
        } catch (Exception e) {
            log.error("내 점수 조회 실패: key={}, userId={}", key, userId, e);
            return null;
        }
    }

    /**
     * 특정 범위(Window) 조회 (Start등 ~ End등)
     * 
     * @param key   랭킹 키
     * @param start 시작 인덱스 (0-based)
     * @param end   종료 인덱스 (0-based)
     * @return 해당 범위의 랭킹 리스트
     *
     *         사용처:
     *         - 내 등수 앞뒤 2명 조회
     */
    public Set<ZSetOperations.TypedTuple<Object>> getRankWindow(String key, long start, long end) {
        try {
            return rankingRedisTemplate.opsForZSet().reverseRangeWithScores(key, start, end);
        } catch (Exception e) {
            log.error("랭킹 윈도우 조회 실패: key={}", key, e);
            return Collections.emptySet();
        }
    }

    /**
     * ✅ [추가] 랭킹 키 삭제 (테스트 정리용)
     * 
     * @param key 삭제할 랭킹 키
     *
     *            사용처:
     *            - 테스트 setUp/tearDown에서 Redis 초기화
     */
    public void deleteRankingKey(String key) {
        try {
            Boolean deleted = rankingRedisTemplate.delete(key);
            log.debug("랭킹 키 삭제: key={}, deleted={}", key, deleted);
        } catch (Exception e) {
            log.error("랭킹 키 삭제 실패: key={}", key, e);
        }
    }

    /**
     * ✅ [추가] 랭킹 키 존재 여부 확인
     * 
     * @param key 랭킹 키
     * @return 존재 여부
     */
    public boolean existsRankingKey(String key) {
        try {
            Boolean exists = rankingRedisTemplate.hasKey(key);
            return Boolean.TRUE.equals(exists);
        } catch (Exception e) {
            log.error("랭킹 키 존재 확인 실패: key={}", key, e);
            return false;
        }
    }

    /**
     * ✅ [추가] 랭킹 전체 삭제 (특정 키의 모든 데이터)
     * 
     * @param key 랭킹 키
     * @return 삭제된 항목 수
     */
    public Long clearRanking(String key) {
        try {
            Long count = rankingRedisTemplate.opsForZSet().zCard(key);
            rankingRedisTemplate.delete(key);
            log.info("랭킹 전체 삭제: key={}, count={}", key, count);
            return count;
        } catch (Exception e) {
            log.error("랭킹 전체 삭제 실패: key={}", key, e);
            return 0L;
        }
    }

    /**
     * ✅ [추가] 특정 사용자 랭킹에서 제거
     * 
     * @param key    랭킹 키
     * @param userId 사용자 ID
     */
    public void removeFromRanking(String key, String userId) {
        try {
            Long removed = rankingRedisTemplate.opsForZSet().remove(key, userId);
            log.debug("랭킹에서 사용자 제거: key={}, userId={}, removed={}", key, userId, removed);
        } catch (Exception e) {
            log.error("랭킹 사용자 제거 실패: key={}, userId={}", key, userId, e);
        }
    }

    /**
     * ✅ [추가] 랭킹 전체 인원 수 조회
     * 
     * @param key 랭킹 키
     * @return 총 인원 수
     */
    public long getRankingSize(String key) {
        try {
            Long size = rankingRedisTemplate.opsForZSet().zCard(key);
            return size != null ? size : 0L;
        } catch (Exception e) {
            log.error("랭킹 사이즈 조회 실패: key={}", key, e);
            return 0L;
        }
    }
}
