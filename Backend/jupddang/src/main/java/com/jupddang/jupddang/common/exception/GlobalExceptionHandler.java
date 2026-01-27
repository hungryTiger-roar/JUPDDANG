package com.jupddang.jupddang.common.exception;

import com.jupddang.jupddang.trashcan.exception.DuplicateVerificationException;
import com.jupddang.jupddang.trashcan.exception.TrashcanAlreadyVerifiedException;
import com.jupddang.jupddang.trashcan.exception.TrashcanNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * 이미지 업로드 예외 처리
     */
    @ExceptionHandler(ImageUploadException.class)
    public ResponseEntity<ErrorResponse> handleImageUploadException(
            ImageUploadException e
    ) {
        log.error("ImageUploadException: {}", e.getMessage());
        ErrorResponse response = new ErrorResponse(
                "IMAGE_UPLOAD_ERROR",
                e.getMessage()
        );
        return ResponseEntity.badRequest().body(response);
    }

    /**
     * 파일 크기 초과 예외 처리
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ErrorResponse> handleMaxUploadSizeExceeded(
            MaxUploadSizeExceededException e
    ) {
        log.error("파일 크기 초과", e);
        ErrorResponse response = new ErrorResponse(
                "FILE_TOO_LARGE",
                "파일 크기는 5MB 이하여야 합니다"
        );
        return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                .body(response);
    }

    /**
     * IllegalArgumentException 예외 처리
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(
            IllegalArgumentException e
    ) {
        log.error("IllegalArgumentException: {}", e.getMessage());
        ErrorResponse response = new ErrorResponse(
                "BAD_REQUEST",
                e.getMessage()
        );
        return ResponseEntity.badRequest().body(response);
    }

    /**
     * 일반 예외 처리
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception e) {
        log.error("Unexpected error", e);
        ErrorResponse response = new ErrorResponse(
                "INTERNAL_SERVER_ERROR",
                "서버 오류가 발생했습니다"
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(response);
    }

    // TrashcanNotFoundException 처리
    @ExceptionHandler(TrashcanNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleTrashcanNotFound(TrashcanNotFoundException ex) {
        log.error("Trashcan not found: {}", ex.getMessage());
        ErrorResponse error = new ErrorResponse("NOT_FOUND", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    // TrashcanAlreadyVerifiedException 처리
    @ExceptionHandler(TrashcanAlreadyVerifiedException.class)
    public ResponseEntity<ErrorResponse> handleTrashcanAlreadyVerified(TrashcanAlreadyVerifiedException ex) {
        log.error("Trashcan already verified: {}", ex.getMessage());
        ErrorResponse error = new ErrorResponse("BAD_REQUEST", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    // DuplicateVerificationException 처리
    @ExceptionHandler(DuplicateVerificationException.class)
    public ResponseEntity<ErrorResponse> handleDuplicateVerification(DuplicateVerificationException ex) {
        log.error("Duplicate verification: {}", ex.getMessage());
        ErrorResponse error = new ErrorResponse("CONFLICT", ex.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }
}