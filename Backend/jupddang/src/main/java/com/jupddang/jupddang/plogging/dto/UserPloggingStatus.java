package com.jupddang.jupddang.plogging.dto;


import java.io.Serializable;

public record UserPloggingStatus(
        String h3Index,
        Long entryTime
) implements Serializable {
    // Serializable은 Redis 직렬화 방식에 따라
}