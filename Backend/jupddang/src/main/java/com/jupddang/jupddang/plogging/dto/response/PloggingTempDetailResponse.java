package com.jupddang.jupddang.plogging.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 임시 저장 상세 응답 (게시글 폼에 채울 데이터)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PloggingTempDetailResponse {
    private Long ploggingId;
    private String recordName;
    private Double distance;
    private Integer times;
    private Integer score;
    private String beforeImageUrl;
    private String afterImageUrl;
    private String mapImageUrl;
    private String content;
    private LocalDateTime createdAt;
}
