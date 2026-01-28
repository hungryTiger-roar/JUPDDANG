package com.jupddang.jupddang.party.dto.response;

import com.jupddang.jupddang.party.domain.ActivityStatus;
import java.time.LocalDateTime;

public record ActivityCompleteResponse(
        Long activityId,
        Long partyId,
        String userId,
        ActivityStatus status,
        LocalDateTime endedAt,

        Long ploggingId,
        Double distance,
        Integer times,

        Long postId,
        String beforeImageUrl,
        String afterImageUrl,
        String mapImageUrl
) {}