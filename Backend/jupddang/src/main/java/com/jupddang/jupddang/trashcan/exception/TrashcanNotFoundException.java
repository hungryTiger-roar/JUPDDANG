package com.jupddang.jupddang.trashcan.exception;

public class TrashcanNotFoundException extends RuntimeException {
    public TrashcanNotFoundException(Long id) {
        super("쓰레기통을 찾을 수 없습니다. ID: " + id);
    }
}