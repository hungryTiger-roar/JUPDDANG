package com.jupddang.jupddang.party.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;

/**
 * 전역 예외 처리 핸들러
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * PartyException 처리
     */
    @ExceptionHandler(PartyException.class)
    public ResponseEntity<ErrorResponse> handlePartyException(PartyException e) {
        ErrorResponse errorResponse = ErrorResponse.of(
                e.getMessage(),
                HttpStatus.BAD_REQUEST.value()
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(errorResponse);
    }

    /**
     * InviteCodeGenerationException 처리
     */
    @ExceptionHandler(InviteCodeGenerationException.class)
    public ResponseEntity<ErrorResponse> handleInviteCodeGenerationException(
            InviteCodeGenerationException e) {

        ErrorResponse errorResponse = ErrorResponse.of(
                e.getMessage(),
                HttpStatus.INTERNAL_SERVER_ERROR.value()
        );

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(errorResponse);
    }

    /**
     * 일반 예외 처리
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception e) {
        ErrorResponse errorResponse = ErrorResponse.of(
                "서버 내부 오류가 발생했습니다.",
                HttpStatus.INTERNAL_SERVER_ERROR.value()
        );

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(errorResponse);
    }

    /**
     * 에러 응답 DTO (Record)
     */
    public record ErrorResponse(
            String message,
            int status,
            LocalDateTime timestamp
    ) {
        public static ErrorResponse of(String message, int status) {
            return new ErrorResponse(message, status, LocalDateTime.now());
        }
    }
}