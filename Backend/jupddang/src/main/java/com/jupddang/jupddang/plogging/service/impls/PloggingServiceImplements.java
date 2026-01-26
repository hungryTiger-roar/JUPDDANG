package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.PloggingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@Slf4j
public class PloggingServiceImplements implements PloggingService {

    private final PloggingRepository ploggingRepository;
    private final GridRepository gridRepository;
    private final
    ApplicationEventPublisher eventPublisher;

    public PloggingServiceImplements(PloggingRepository ploggingRepository, GridRepository gridRepository, ApplicationEventPublisher eventPublisher) {
        this.ploggingRepository = ploggingRepository;
        this.gridRepository = gridRepository;
        this.eventPublisher = eventPublisher;
    }

    @Override
    @Transactional
    public PloggingResultResponse endPlogging(
            Long userId,
            PloggingEndRequest request,
            MultipartFile beforeImage,
            MultipartFile afterImage,
            MultipartFile mapImage) {

        log.info("플로깅 종료 - userId: {}", userId);

        // 1. Plogging 저장 (간단한 버전)
        Plogging plogging = Plogging.builder()
                .userId(userId)
                .distance(request.distance())
                .times(1)
                .build();

        Plogging savedPlogging = ploggingRepository.save(plogging);
        log.info("Plogging 저장 완료 - ploggingId: {}", savedPlogging.getId());

        // 2. 그리드 계산 (임시로 10 설정)
        int occupiedGridCnt = 10;  // 나중에 실제 계산 로직으로 변경
        int totalScore = 100;      // 나중에 실제 점수 계산 로직으로 변경

        // 3. Event 발행 (피드 생성 트리거)
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(String.valueOf(userId))
                .beforeImage(beforeImage)
                .afterImage(afterImage)
                .mapImage(mapImage)
                .occupiedGridCnt(occupiedGridCnt)
                .build();

        log.info("PloggingCompletedEvent 발행 - ploggingId: {}", savedPlogging.getId());
        eventPublisher.publishEvent(event);

        // 4. 응답 반환
        return new PloggingResultResponse(
                "플로깅 완료!",
                totalScore,
                occupiedGridCnt
        );
    }

    @Override
    public void test() {

    }


//


}
