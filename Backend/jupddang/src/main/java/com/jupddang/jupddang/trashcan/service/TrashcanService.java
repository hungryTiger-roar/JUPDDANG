package com.jupddang.jupddang.trashcan.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.trashcan.dto.TrashcanCreateRequest;
import com.jupddang.jupddang.trashcan.dto.TrashcanDetailDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanListResponse;
import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import com.jupddang.jupddang.trashcan.repository.TrashcanVerificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.jupddang.jupddang.trashcan.exception.TrashcanNotFoundException;
import com.jupddang.jupddang.trashcan.exception.TrashcanAlreadyVerifiedException;
import com.jupddang.jupddang.trashcan.exception.DuplicateVerificationException;
import com.jupddang.jupddang.trashcan.repository.TrashcanVerificationRepository;
import com.jupddang.jupddang.trashcan.entity.TrashcanVerification;
import java.time.LocalDateTime;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TrashcanService {

    private final TrashcanRepository trashcanRepository;
    private final AccountRepository accountRepository;
    private final TrashcanVerificationRepository verificationRepository;

    /**
     * 지도 영역 내의 쓰레기통 조회
     *
     * @param minLatitude 최소 위도
     * @param maxLatitude 최대 위도
     * @param minLongitude 최소 경도
     * @param maxLongitude 최대 경도
     * @return 쓰레기통 목록
     */
    public TrashcanListResponse getTrashcansInArea(
            Double minLatitude,
            Double maxLatitude,
            Double minLongitude,
            Double maxLongitude) {

        // 파라미터 유효성 검사
        validateCoordinates(minLatitude, maxLatitude, minLongitude, maxLongitude);

        // DB 조회
        List<Trashcan> trashcans = trashcanRepository.findByLocationRange(
                minLatitude, maxLatitude, minLongitude, maxLongitude
        );

        log.info("조회된 쓰레기통 개수: {}", trashcans.size());

        // Entity → DTO 변환
        List<TrashcanDto> dtos = trashcans.stream()
                .map(TrashcanDto::from)
                .toList();

        return TrashcanListResponse.of(dtos);
    }

    /**
     * 좌표 유효성 검증
     */
    private void validateCoordinates(
            Double minLat, Double maxLat,
            Double minLng, Double maxLng) {

        if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
            throw new IllegalArgumentException("모든 좌표 값은 필수입니다");
        }

        if (minLat >= maxLat) {
            throw new IllegalArgumentException("최소 위도는 최대 위도보다 작아야 합니다");
        }

        if (minLng >= maxLng) {
            throw new IllegalArgumentException("최소 경도는 최대 경도보다 작아야 합니다");
        }

        // 한국 좌표 범위 검증
        if (minLat < 33.0 || maxLat > 43.0) {
            throw new IllegalArgumentException("위도는 33.0 ~ 43.0 범위여야 합니다");
        }

        if (minLng < 124.0 || maxLng > 132.0) {
            throw new IllegalArgumentException("경도는 124.0 ~ 132.0 범위여야 합니다");
        }
    }

    /**
     * 새로운 쓰레기통 위치 추가
     *
     * @param request 쓰레기통 정보
     * @param userId 제안한 사용자 ID
     * @return 생성된 쓰레기통 정보
     */
    @Transactional
    public TrashcanDetailDto createTrashcan(TrashcanCreateRequest request, String userId) {
        // 요청 유효성 검증
        request.validate();

        Account account = accountRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다: " + userId));

        // 새로운 Trashcan 엔티티 생성
        Trashcan trashcan = new Trashcan();
        trashcan.setLatitude(request.latitude());
        trashcan.setLongitude(request.longitude());
        trashcan.setAddress(request.address());
        trashcan.setStatus(TrashcanStatus.PENDING);  // 초기 상태: 인증 대기
        trashcan.setReportedBy(account);
        trashcan.setVerificationCount(0);

        // DB 저장
        Trashcan saved = trashcanRepository.save(trashcan);

        log.info("새로운 쓰레기통 위치 추가: id={}, userId={}, lat={}, lng={}",
                saved.getId(), userId, saved.getLatitude(), saved.getLongitude());

        return TrashcanDetailDto.from(saved);
    }

    /**
     * 쓰레기통 검증
     *
     * @param trashcanId 검증할 쓰레기통 ID
     * @param account 검증하는 사용자
     * @return 검증 후 쓰레기통 정보
     */
    @Transactional
    public TrashcanDetailDto verifyTrashcan(Long trashcanId, Account account) {

        // 1. 쓰레기통 조회
        Trashcan trashcan = trashcanRepository.findById(trashcanId)
                .orElseThrow(() -> new TrashcanNotFoundException(trashcanId));

        // 2. 이미 검증 완료된 쓰레기통인지 확인
        if (trashcan.getStatus() == TrashcanStatus.VERIFIED) {
            throw new TrashcanAlreadyVerifiedException(trashcanId);
        }

        // 3. 중복 검증 확인 (같은 사용자가 이미 검증했는지)
        boolean alreadyVerified = verificationRepository
                .existsByTrashcan_IdAndUser(trashcanId, account);

        if (alreadyVerified) {
            throw new DuplicateVerificationException(trashcanId, account.getUserId());
        }

        // 4. 검증 레코드 생성
        TrashcanVerification verification = TrashcanVerification.builder()
                .trashcan(trashcan)
                .user(account)
                .build();
        verificationRepository.save(verification);

        // 5. 검증 횟수 증가
        trashcan.setVerificationCount(trashcan.getVerificationCount() + 1);

        // 6. 3회 이상 검증되면 상태를 VERIFIED로 변경
        if (trashcan.getVerificationCount() >= 3) {
            trashcan.setStatus(TrashcanStatus.VERIFIED);
        }

        // 7. 변경사항 저장 (dirty checking으로 자동 저장됨)
        trashcanRepository.save(trashcan);

        // 8. DTO 변환 및 반환
        return TrashcanDetailDto.from(trashcan);
    }

    /**
     * 내가 제안한 쓰레기통 목록 조회
     *
     * @param account 조회하는 사용자
     * @param status 필터링할 상태 (null이면 전체 조회)
     * @return 쓰레기통 목록
     */
    @Transactional(readOnly = true)
    public TrashcanListResponse getMyTrashcans(Account account, TrashcanStatus status) {

        // 1. status에 따라 다른 조회 메서드 호출
        List<Trashcan> trashcans;

        if (status == null) {
            // 전체 조회
            trashcans = trashcanRepository.findByReportedByOrderByIdDesc(account);
        } else {
            // 특정 상태만 조회
            trashcans = trashcanRepository.findByReportedByAndStatusOrderByIdDesc(account, status);
        }

        // 2. Entity → DTO 변환
        List<TrashcanDto> trashcanDtos = trashcans.stream()
                .map(trashcan -> new TrashcanDto(
                        trashcan.getId(),
                        trashcan.getLatitude(),
                        trashcan.getLongitude(),
                        trashcan.getAddress(),
                        trashcan.getStatus()
                ))
                .toList();

        // 3. Response 생성 및 반환
        return new TrashcanListResponse(trashcanDtos);
    }
}