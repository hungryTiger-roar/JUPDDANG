package com.jupddang.jupddang.ranking.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.enums.PloggingLevel;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.ranking.dto.RankingListResponseDto;
import com.jupddang.jupddang.ranking.dto.RankingResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RankingService {
    private final AccountRepository accountRepository;
    private final PloggingRepository ploggingRepository;

    // 1. 전체(누적) 랭킹 (페이징 적용 + 내 등수 포함)
    public RankingListResponseDto getTotalRanking(int page, int size, String userId) {
        // 내 정보 조회
        Account me = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 랭킹 리스트 조회 (페이징)
        Slice<Account> accountSlice = accountRepository.findAllByOrderByScoreDesc(PageRequest.of(page, size));

        List<RankingResponseDto> rankingDtos = new ArrayList<>();
        int currentRank = (page * size) + 1; // 0페이지면 1등부터, 1페이지(size 10)면 11등부터

        for (Account account : accountSlice) {
            rankingDtos.add(convertToDto(account, currentRank++, (long)account.getScore()));
        }

        // 내 등수 계산 (전체 점수 기준)
        long myCount = accountRepository.countByScoreGreaterThan(me.getScore());
        RankingResponseDto myRankingDto = convertToDto(me, (int) myCount + 1, (long)me.getScore());

        return RankingListResponseDto.builder()
                .topRankings(rankingDtos)
                .myRanking(myRankingDto) // ★ 내 랭킹 포함됨
                .build();
    }

    // 2. 월간 랭킹 (날짜 자동 + 내 점수 포함)
    public RankingListResponseDto getMonthlyRanking(Integer year, Integer month, String userId) {
        Account me = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 날짜가 없으면 현재 날짜로 자동 설정
        if (year == null) year = LocalDate.now().getYear();
        if (month == null) month = LocalDate.now().getMonthValue();

        // 해당 월의 시작과 끝 계산
        LocalDateTime start = LocalDateTime.of(year, month, 1, 0, 0, 0);
        LocalDateTime end = start.plusMonths(1).minusSeconds(1);

        // 월간 랭킹 리스트 (일단 상위 10명만 조회하도록 설정, 필요시 파라미터화 가능)
        List<Object[]> results = ploggingRepository.findMonthlyRanking(start, end, PageRequest.of(0, 10));

        List<RankingResponseDto> rankingDtos = new ArrayList<>();
        int rank = 1;
        for (Object[] row : results) {
            rankingDtos.add(RankingResponseDto.builder()
                    .rank(rank++)
                    .userId((String) row[0])
                    .nickname((String) row[1])
                    .profileImage((String) row[2])
                    .score((Long) row[3])
                    .tier(PloggingLevel.findByScore((Long) row[3]).getLabel())
                    .build());
        }

        // 내 월간 점수 조회 (없으면 0점)
        long myMonthlyScore = ploggingRepository.sumScoreByAccountAndDate(me, start, end).orElse(0L);

        // 내 월간 정보 생성 (월간 등수 계산은 복잡해서 일단 점수만 정확히 표기하고 등수는 0 처리)
        RankingResponseDto myRankingDto = RankingResponseDto.builder()
                .rank(0) // 월간 내 등수는 별도 집계 필요 (일단 0)
                .userId(me.getUserId())
                .nickname(me.getNickname())
                .profileImage(me.getProfileImage())
                .score(myMonthlyScore) // ★ 이번 달 내 점수
                .tier(PloggingLevel.findByScore(myMonthlyScore).getLabel())
                .build();

        return RankingListResponseDto.builder()
                .topRankings(rankingDtos)
                .myRanking(myRankingDto) // ★ 내 랭킹(점수) 포함됨
                .build();
    }

    // DTO 변환 헬퍼 메서드
    private RankingResponseDto convertToDto(Account account, int rank, Long score) {
        return RankingResponseDto.builder()
                .rank(rank)
                .userId(account.getUserId())
                .nickname(account.getNickname())
                .profileImage(account.getProfileImage())
                .score(score)
                .tier(PloggingLevel.findByScore(score).getLabel())
                .build();
    }
}