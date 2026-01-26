package com.jupddang.jupddang.ranking.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.enums.PloggingLevel;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.ranking.dto.RankingListResponseDto;
import com.jupddang.jupddang.ranking.dto.RankingResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RankingService {
    private final AccountRepository accountRepository;
    private final PloggingRepository ploggingRepository; // 월간 랭킹

    public RankingListResponseDto getRankingList(String type, String userId) {

        List<RankingResponseDto> rankingDtos = new ArrayList<>();
        RankingResponseDto myRankingDto = null;

        Account me = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 월간 랭킹
        if ("MONTHLY".equals(type)) {
            // 이번 달 1일 ~ 말일 계산
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime start = now.withDayOfMonth(1).truncatedTo(ChronoUnit.DAYS);
            LocalDateTime end = now.withDayOfMonth(now.toLocalDate().lengthOfMonth())
                    .withHour(23).withMinute(59).withSecond(59);

            // 레포지토리 호출 (상위 10개)
            List<Object[]> results = ploggingRepository.findMonthlyRanking(start, end, PageRequest.of(0, 10));

            // DTO 변환
            int rank = 1;
            for (Object[] row : results) {
                String uId = (String) row[0];
                String nick = (String) row[1];
                String pImg = (String) row[2];
                Long scoreSum = (Long) row[3];

                // ★ 여기서 Enum 활용!
                String tierLabel = PloggingLevel.findByScore(scoreSum).getLabel();

                rankingDtos.add(RankingResponseDto.builder()
                        .rank(rank++)
                        .userId(uId)
                        .nickname(nick)
                        .profileImage(pImg)
                        .score(scoreSum)
                        .tier(tierLabel) // Enum에서 가져온 라벨(Gold 1 등)
                        .build());
            }
            // 월간 내 정보 (일단 0등 처리, 필요시 별도 구현)
            myRankingDto = convertToDto(me, 0);
        }

        // 전체 랭킹 (TOTAL) - 기존 로직
        else {
            List<Account> topAccounts = accountRepository.findTop10ByOrderByScoreDesc();

            int rank = 1;
            for (Account account : topAccounts) {
                rankingDtos.add(convertToDto(account, rank++));
            }

            long count = accountRepository.countByScoreGreaterThan(me.getScore());
            int myRank = (int) count + 1;

            myRankingDto = convertToDto(me, myRank);
        }

        return RankingListResponseDto.builder()
                .topRankings(rankingDtos)
                .myRanking(myRankingDto)
                .build();
    }

    private RankingResponseDto convertToDto(Account account, int rank) {

        // ★ 여기서도 Enum 활용!
        String tierLabel = PloggingLevel.findByScore((long) account.getScore()).getLabel();

        return RankingResponseDto.builder()
                .rank(rank)
                .userId(account.getUserId())
                .nickname(account.getNickname())
                .profileImage(account.getProfileImage())
                .score((long) account.getScore())
                .tier(tierLabel) // Enum이 계산해준 라벨 사용
                .build();

    }
}
