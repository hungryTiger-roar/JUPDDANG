package com.jupddang.jupddang.plogging.service;

import com.jupddang.jupddang.plogging.dto.response.TrashDetectionResponse;
import org.springframework.web.multipart.MultipartFile;

/**
 * 쓰레기 탐지 서비스 인터페이스
 */
public interface TrashDetectionService {

    /**
     * 이미지에서 쓰레기 탐지 수행
     * 
     * @param image 분석할 이미지
     * @return 탐지 결과 (Bounding Box 좌표 포함)
     */
    TrashDetectionResponse detectTrash(MultipartFile image);
}
