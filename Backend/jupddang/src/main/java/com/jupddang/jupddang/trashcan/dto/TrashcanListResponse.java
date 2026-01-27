package com.jupddang.jupddang.trashcan.dto;

import java.util.List;

/**
 * 쓰레기통 목록 응답
 */
public record TrashcanListResponse(
        List<TrashcanDto> trashcans
) {
    public static TrashcanListResponse of(List<TrashcanDto> trashcans) {
        return new TrashcanListResponse(trashcans);
    }
}