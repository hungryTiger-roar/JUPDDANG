package com.jupddang.jupddang.plogging.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum PloggingErrorCode {
    // GIS / H3 관련
    GIS_NOT_FOUND(HttpStatus.NOT_FOUND, "해당 GIS 정보를 찾을 수 없습니다."),
    INVALID_COORDINATE(HttpStatus.BAD_REQUEST, "유효하지 않은 위경도 좌표입니다."),
    H3_CONVERSION_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "좌표를 H3 인덱스로 변환하는 중 오류가 발생했습니다."),

    // Plogging 관련
    PLOGGING_NOT_FOUND(HttpStatus.NOT_FOUND, "해당 플로깅 세션을 찾을 수 없습니다."),
    LOCATION_PROCESSING_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "위치 정보 처리 중 오류가 발생했습니다."),  // 🎯 추가

    // Party / Plogging
    PARTY_NOT_FOUND(HttpStatus.NOT_FOUND, "Party not found."),
    PARTY_MEMBER_NOT_FOUND(HttpStatus.FORBIDDEN, "User is not a member of the party."),
    PARTY_NOT_IN_PROGRESS(HttpStatus.CONFLICT, "Party is not in progress."),
    PARTY_ACTIVE_BLOCKS_SOLO(HttpStatus.CONFLICT, "User is in an active party."),

    // 공통
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버 내부 오류입니다."),

    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "해당 유저를 찾을 수 없습니다.");

    private final HttpStatus httpStatus;
    private final String message;
}