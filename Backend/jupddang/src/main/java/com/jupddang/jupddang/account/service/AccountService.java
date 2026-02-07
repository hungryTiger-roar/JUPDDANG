package com.jupddang.jupddang.account.service;

import com.jupddang.jupddang.account.dto.*;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.enums.PloggingLevel;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.follow.repository.FollowRepository;
import com.jupddang.jupddang.ranking.repository.RankingRedisRepository;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AccountService {

    private final AccountRepository accountRepository;
    private final AuthenticationManager authenticationManager;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final GcsImageService gcsImageService;
    private final FollowRepository followRepository;
    private final RankingRedisRepository rankingRedisRepository;

    @Transactional
    public AccountResponse createAccount(AccountCreateRequest request) {

        if (accountRepository.existsById(request.getUserId())) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        // [추가] 이메일 중복 체크 (Repository에 existsByEmail 메서드 필요)
        if (accountRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("이미 존재하는 이메일입니다.");
        }


        Account account = Account.builder()
                .userId(request.getUserId())
                .pw(bCryptPasswordEncoder.encode(request.getPw()))
                .email(request.getEmail())
                .nickname(request.getNickname())
                .color(request.getColor())
                .build();

        return AccountResponse.from(accountRepository.save(account));
    }

    @Transactional(readOnly = true)
    public List<AccountResponse> getAllAccounts() {
        return accountRepository.findAll().stream()
                .map(account -> {
                    // 누적 랭킹 확인하여 LEGEND 처리
                    String tier = getTierWithLegendCheck(account);
                    return AccountResponse.from(account, tier);
                })
                .toList();
    }

    @Transactional(readOnly = true)
    public AccountLoginResponse login(AccountLoginRequest request) {

        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUserId(),
                        request.getPw()
                )
        );

        Account account = (Account) auth.getPrincipal();

        String accessToken = jwtTokenProvider.createAccessToken(
                account.getUserId(),
                account.getAuthorities().stream()
                        .map(grantedAuthority -> grantedAuthority.getAuthority())
                        .toList()
        );

        return AccountLoginResponse.of(
                accessToken,
                jwtTokenProvider.getAccessTokenExpiresInSeconds(),
                AccountResponse.from(account)
        );
    }

    @Transactional(readOnly = true)
    public AccountResponse getAccount(String targetUserId, Account loginUser) {
        Account target = accountRepository.findByUserId(targetUserId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 1. 내가 이 사람을 팔로우 중인지 확인
        boolean isFollowing = false;
        if (loginUser != null) {
            isFollowing = followRepository.findByFollowerAndFollowing(loginUser, target).isPresent();
        }

        // 2. 팔로워/팔로잉 숫자 카운트
        long followerCount = followRepository.countByFollowing(target);
        long followingCount = followRepository.countByFollower(target);

        // 3. 누적 랭킹 확인하여 LEGEND 처리
        String tier = getTierWithLegendCheck(target);

        return AccountResponse.from(target, isFollowing, followerCount, followingCount, tier);
    }

    /**
     * 누적 랭킹 1~3등이면 LEGEND 티어를 반환, 아니면 Account의 tier 반환
     */
    private String getTierWithLegendCheck(Account account) {
        try {
            // 누적 랭킹에서 등수 확인
            Long rank = rankingRedisRepository.getMyRank("ranking:total", account.getUserId());

            // 1~3등이면 LEGEND 반환
            if (rank != null && rank >= 0 && rank <= 2) {  // Redis는 0-based index
                return PloggingLevel.LEGEND.getLabel();
            }
        } catch (Exception e) {
            log.warn("랭킹 조회 실패 (tier는 기본값 사용): {}", e.getMessage());
        }

        // 그 외에는 Account의 tier 반환
        return account.getTier();
    }

    @Transactional
    public AccountResponse updateAccount(String userId, AccountUpdateRequest request, MultipartFile image) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        String encodedPw = null;
        String imageUrl = null;

        // 1. 비밀번호 암호화
        if (request != null && request.getPw() != null && !request.getPw().isBlank()) {
            encodedPw = bCryptPasswordEncoder.encode(request.getPw());
        }

        // 2. 이미지 업로드 처리
        if (image != null && !image.isEmpty()) {
            // 기존 이미지가 기본 이미지가 아니면 삭제
            if (account.getProfileImage() != null &&
                    !account.getProfileImage().contains("default-profile.png")) {
                try {
                    gcsImageService.deleteImage(account.getProfileImage());
                } catch (Exception e) {
                    log.warn("기존 이미지 삭제 실패 (계속 진행): {}", e.getMessage());
                }
            }
            imageUrl = gcsImageService.uploadImage(image, "profile");
        }

        // 3. 업데이트 (region 삭제됨, 순서: pw, nickname, profileImage, intro, email, color)
        account.update(
                encodedPw,
                request != null ? request.getNickname() : null,
                imageUrl,
                request != null ? request.getIntro() : null,
                request != null ? request.getEmail() : null,
                request != null ? request.getColor() : null
        );

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse deleteAccount(String userId) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        if (account.getProfileImage() != null &&
                !account.getProfileImage().contains("default-profile.png")) {
            try {
                gcsImageService.deleteImage(account.getProfileImage());
            } catch (Exception e) {
                log.error("이미지 삭제 실패 (탈퇴 진행): {}", e.getMessage());
            }
        }

        accountRepository.delete(account);
        return AccountResponse.from(account);
    }

    /**
     * 모든 계정의 tier를 total_score에 맞게 재계산
     * 더미 데이터 수정용 (개발/테스트 환경에서만 사용)
     */
    @Transactional
    public int recalculateAllTiers() {
        List<Account> allAccounts = accountRepository.findAll();
        int updatedCount = 0;

        for (Account account : allAccounts) {
            String currentTier = account.getTier();
            String correctTier = PloggingLevel.findByScore(account.getTotalScore()).getLabel();

            // tier가 다르면 재계산
            if (!currentTier.equals(correctTier)) {
                // addScore(0)을 호출하면 tier가 재계산됨
                account.addScore(0);
                updatedCount++;
                log.info("Updated tier for {}: {} -> {}",
                    account.getUserId(), currentTier, correctTier);
            }
        }

        log.info("Total {} accounts' tiers updated", updatedCount);
        return updatedCount;
    }
}