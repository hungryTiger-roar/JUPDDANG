package com.jupddang.jupddang.trashcan.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.trashcan.dto.TrashcanCreateRequest;
import com.jupddang.jupddang.trashcan.dto.TrashcanDetailDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanListResponse;
import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.entity.TrashcanVerification;
import com.jupddang.jupddang.trashcan.exception.DuplicateVerificationException;
import com.jupddang.jupddang.trashcan.exception.TrashcanAlreadyVerifiedException;
import com.jupddang.jupddang.trashcan.exception.TrashcanNotFoundException;
import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import com.jupddang.jupddang.trashcan.repository.TrashcanVerificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
     */
    public TrashcanListResponse getTrashcansInArea(
            Double minLatitude,
            Double maxLatitude,
            Double minLongitude,
            Double maxLongitude) {

        validateCoordinates(minLatitude, maxLatitude, minLongitude, maxLongitude);

        List<Trashcan> trashcans = trashcanRepository.findByLocationRange(
                minLatitude, maxLatitude, minLongitude, maxLongitude
        );

        log.info("조회된 쓰레기통 개수: {}", trashcans.size());

        List<TrashcanDto> dtos = trashcans.stream()
                .map(TrashcanDto::from)
                .toList();

        return TrashcanListResponse.of(dtos);
    }

    private void validateCoordinates(Double minLat, Double maxLat, Double minLng, Double maxLng) {
        if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
            throw new IllegalArgumentException("모든 좌표 값은 필수입니다");
        }
        if (minLat >= maxLat) {
            throw new IllegalArgumentException("최소 위도는 최대 위도보다 작아야 합니다");
        }
        if (minLng >= maxLng) {
            throw new IllegalArgumentException("최소 경도는 최대 경도보다 작아야 합니다");
        }
        if (minLat < 33.0 || maxLat > 43.0) {
            throw new IllegalArgumentException("위도는 33.0 ~ 43.0 범위여야 합니다");
        }
        if (minLng < 124.0 || maxLng > 132.0) {
            throw new IllegalArgumentException("경도는 124.0 ~ 132.0 범위여야 합니다");
        }
    }

    /**
     * 새로운 쓰레기통 위치 추가
     */
    @Transactional
    public TrashcanDetailDto createTrashcan(TrashcanCreateRequest request, String userId) {
        request.validate();

        Account account = accountRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다: " + userId));

        Trashcan trashcan = new Trashcan();
        trashcan.setLatitude(request.latitude());
        trashcan.setLongitude(request.longitude());
        trashcan.setAddress(request.address());
        trashcan.setStatus(TrashcanStatus.PENDING);
        trashcan.setReportedBy(account);
        trashcan.setVerificationCount(0);

        Trashcan saved = trashcanRepository.save(trashcan);

        log.info("새로운 쓰레기통 위치 추가: id={}, userId={}, lat={}, lng={}",
                saved.getId(), userId, saved.getLatitude(), saved.getLongitude());

        return TrashcanDetailDto.from(saved);
    }

    /**
     * 쓰레기통 검증 (동시성 제어 로직 적용)
     */
    @Transactional
    public TrashcanDetailDto verifyTrashcan(Long trashcanId, Account account) {

        // 1. 중복 검증 확인
        if (verificationRepository.existsByTrashcan_IdAndUser(trashcanId, account)) {
            throw new DuplicateVerificationException(trashcanId, account.getUserId());
        }

        // 2. 쓰레기통 조회 및 상태 확인
        Trashcan trashcan = trashcanRepository.findById(trashcanId)
                .orElseThrow(() -> new TrashcanNotFoundException(trashcanId));

        if (trashcan.getStatus() == TrashcanStatus.VERIFIED) {
            throw new TrashcanAlreadyVerifiedException(trashcanId);
        }

        // 3. 검증 레코드 생성 (로그 저장)
        verificationRepository.save(TrashcanVerification.builder()
                .trashcan(trashcan)
                .user(account)
                .build());

        // 4. [중요] 카운트 원자적 증가 (JPQL 사용으로 동시성 문제 해결)
        trashcanRepository.increaseVerificationCount(trashcanId);

        // 5. [중요] 조건 충족 시 상태 변경 (JPQL 사용)
        trashcanRepository.updateStatusIfVerified(trashcanId);

        // 6. 최신 데이터 조회 (영속성 컨텍스트가 clear 되었으므로 DB에서 새로 조회)
        Trashcan updatedTrashcan = trashcanRepository.findById(trashcanId)
                .orElseThrow(() -> new TrashcanNotFoundException(trashcanId));

        return TrashcanDetailDto.from(updatedTrashcan);
    }

    /**
     * 내가 제안한 쓰레기통 목록 조회
     */
    public TrashcanListResponse getMyTrashcans(Account account, TrashcanStatus status) {
        List<Trashcan> trashcans;

        if (status == null) {
            trashcans = trashcanRepository.findByReportedByOrderByIdDesc(account);
        } else {
            trashcans = trashcanRepository.findByReportedByAndStatusOrderByIdDesc(account, status);
        }

        List<TrashcanDto> trashcanDtos = trashcans.stream()
                .map(t -> new TrashcanDto(
                        t.getId(), t.getLatitude(), t.getLongitude(), t.getAddress(), t.getStatus()
                ))
                .toList();

        return new TrashcanListResponse(trashcanDtos);
    }
}