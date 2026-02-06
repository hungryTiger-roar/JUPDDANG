package com.jupddang.jupddang.plogging.dto.response;

import java.util.List;

/**
 * 탐지된 쓰레기의 Bounding Box 정보
 * box2d: [ymin, xmin, ymax, xmax] (0~1000 스케일)
 */
public record TrashBoundingBox(
        List<Integer> box2d, // [ymin, xmin, ymax, xmax]
        String label // 예: "trash", "trash_bag"
) {
}
