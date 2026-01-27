package com.jupddang.jupddang.trashcan.exception;

public class TrashcanAlreadyVerifiedException extends RuntimeException {
    public TrashcanAlreadyVerifiedException(Long id) {
        super("이미 검증 완료된 쓰레기통입니다. ID: " + id);
    }
}