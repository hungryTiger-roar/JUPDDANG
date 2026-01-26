package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.plogging.domain.Grids;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GridStatusService {

    private final GridRepository gridRepository;

    // [수정] 파라미터 타입 변경: Long userId -> String userId
    public boolean checkClaimability(String userId, String h3Index) {
        
        // DB에 없으면(빈 땅) true, 있으면 3시간 보호막 로직 체크
        return gridRepository.findById(h3Index)
                // grid.isClaimable()도 이제 String을 받으므로 타입이 일치하게 됨
                .map(grid -> grid.isClaimable(userId, LocalDateTime.now()))
                .orElse(true);
    }
}