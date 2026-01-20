package com.jupddang.jupddang.plogging.domain;

import lombok.Getter;
import lombok.Builder;

// DB 테이블과 상관없는 순수 도메인 객체
@Getter
@Builder
public class Plogging {
    private Long ploggingId;
    private Long userId;
    private Double distance;
    private int times;
}
