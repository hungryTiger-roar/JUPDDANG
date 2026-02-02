package com.jupddang.jupddang.ranking.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.enums.PloggingLevel;
import com.jupddang.jupddang.ranking.repository.RankingRedisRepository;
import com.jupddang.jupddang.ranking.dto.RankingListResponseDto;
import com.jupddang.jupddang.ranking.dto.RankingResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RankingService {
    private final AccountRepository accountRepository;
    private final RankingRedisRepository rankingRedisRepository;

    /**
     * 1. 전체(누적) 랭킹 조회
     * Redis Key: "ranking:total"
     */
    public RankingListResponseDto getTotalRanking(String userId) {
        return getRankingResponse("ranking:total", userId);
    }

    /**
     * 2. 월간 랭킹 조회
     * Redis Key: "ranking:monthly:YYYYMM"
     */
    public RankingListResponseDto getMonthlyRanking(Integer year, Integer month, String userId) {
        // 날짜 없으면 현재 날짜 기준
        if (year == null)
            year = LocalDate.now().getYear();
        if (month == null)
            month = LocalDate.now().getMonthValue();

        // 키 생성 (예: ranking:monthly:202602)
        String redisKey = String.format("ranking:monthly:%04d%02d", year, month);

        return getRankingResponse(redisKey, userId);
    }

    // [Redis]
    // 내부 로직: Redis에서 데이터를 가져와 DTO로 변환하는 핵심 메서드
    private RankingListResponseDto getRankingResponse(String redisKey, String userId) {

        // [Redis에서 랭킹 데이터 조회]
        // 1. Top 3 가져오기
        Set<ZSetOperations.TypedTuple<Object>> top3Set = rankingRedisRepository.getTopRankers(redisKey, 3);

        // 2. 내 등수 조회
        Long myRank = rankingRedisRepository.getMyRank(redisKey, userId);

        // 3. 내 주변 랭킹 가져오기
        List<ZSetOperations.TypedTuple<Object>> windowList = new ArrayList<>();
        long windowStartRank = 0;

        if (myRank != null) {
            // 내 등수 기준 앞뒤 2명 계산 (start ~ end)
            long start = Math.max(0, myRank - 2);
            long end = myRank + 2;

            Set<ZSetOperations.TypedTuple<Object>> windowSet = rankingRedisRepository.getRankWindow(redisKey, start,
                    end);

            if (windowSet != null) {
                windowList.addAll(windowSet);
            }
            windowStartRank = start; // 윈도우 시작 등수 저장 (DTO 변환 시 +1 하기 위해)
        }

        // [DB에서 사용자 정보 조회(닉네임, 프사 등)]
        // Top3와 윈도우에 있는 모든 유저 ID를 모음(중복 제거)
        Set<String> allUserIds = new HashSet<>();
        for (ZSetOperations.TypedTuple<Object> tuple : top3Set)
            allUserIds.add((String) tuple.getValue());
        for (ZSetOperations.TypedTuple<Object> tuple : windowList)
            allUserIds.add((String) tuple.getValue());

        // DB에서 한 번에 조회
        Map<String, Account> accountMap = accountRepository.findAllByUserIdIn(new ArrayList<>(allUserIds))
                .stream()
                .collect(Collectors.toMap(Account::getUserId, account -> account));

        // [DTO 변환]
        // 1. Top 3 리스트 변환
        List<RankingResponseDto> topRankers = convertToDtoList(top3Set, accountMap, 0);

        // 2. 내 윈도우 리스트 변환
        List<RankingResponseDto> myRankWindow = convertToDtoList(windowList, accountMap, (int) windowStartRank);

        return RankingListResponseDto.builder()
                .topRankers(topRankers)
                .myRankWindow(myRankWindow)
                .build();
    }

    private List<RankingResponseDto> convertToDtoList(
            Collection<ZSetOperations.TypedTuple<Object>> tuples,
            Map<String, Account> accountMap,
            int startRankIndex) {
        List<RankingResponseDto> dtoList = new ArrayList<>();
        int currentRank = startRankIndex + 1;

        if (tuples == null)
            return dtoList;

        for (ZSetOperations.TypedTuple<Object> tuple : tuples) {
            String uid = (String) tuple.getValue();
            Double scoreDouble = tuple.getScore();
            long score = (scoreDouble != null) ? scoreDouble.longValue() : 0L;

            // DB에서 찾아온 유저 정보(없으면 스킵)
            Account account = accountMap.get(uid);
            if (account != null) {
                dtoList.add(RankingResponseDto.builder()
                        .rank(currentRank)
                        .userId(uid)
                        .nickname(account.getNickname())
                        .profileImage(account.getProfileImage())
                        .score(score)
                        .tier(PloggingLevel.findByScore(score).getLabel())
                        .build());
            }
            currentRank++;
        }
        return dtoList;
    }
}