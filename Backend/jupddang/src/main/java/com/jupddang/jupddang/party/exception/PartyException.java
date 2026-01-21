package com.jupddang.jupddang.party.exception;

/**
 * 파티 관련 비즈니스 예외
 */
public class PartyException extends RuntimeException {

    public PartyException(String message) {
        super(message);
    }

    public PartyException(String message, Throwable cause) {
        super(message, cause);
    }
}