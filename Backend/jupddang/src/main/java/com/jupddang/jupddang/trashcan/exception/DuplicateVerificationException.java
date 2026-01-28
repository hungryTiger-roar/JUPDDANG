package com.jupddang.jupddang.trashcan.exception;

public class DuplicateVerificationException extends RuntimeException {
    public DuplicateVerificationException(Long trashcanId, String userId) {
        super("이미 검증한 쓰레기통입니다. 사용자: " + userId + ", 쓰레기통 ID: " + trashcanId);
    }
}