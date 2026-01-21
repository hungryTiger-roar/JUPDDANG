package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.PloggingService;

import java.util.List;

public class PloggingServiceImplements implements PloggingService {

    private final PloggingRepository ploggingRepository;
    private final GridRepository gridRepository;

    public PloggingServiceImplements(PloggingRepository ploggingRepository, GridRepository gridRepository) {
        this.ploggingRepository = ploggingRepository;
        this.gridRepository = gridRepository;
    }

    @Override
    public PloggingResultResponse endPlogging(Long userId, PloggingEndRequest request) {
        return null;
    }

    @Override
    public void test() {

    }


//


}
