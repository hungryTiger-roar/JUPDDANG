package com.jupddang.jupddang.plogging.exception;

import lombok.Getter;

@Getter
public class PloggingException extends RuntimeException {
    private final PloggingErrorCode errorCode;

    public PloggingException(PloggingErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }
}