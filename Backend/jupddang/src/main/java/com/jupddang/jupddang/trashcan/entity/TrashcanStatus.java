package com.jupddang.jupddang.trashcan.entity;

/**
 * 쓰레기통 상태
 * - OFFICIAL: 공공데이터에서 가져온 공식 쓰레기통
 * - PENDING: 사용자가 제안한 임시 쓰레기통 (인증 대기중)
 * - VERIFIED: 3명 이상 인증 완료된 쓰레기통
 */
public enum TrashcanStatus {
    OFFICIAL,    // 공공 쓰레기통
    PENDING,     // 인증 대기중 (1~2명 인증)
    VERIFIED     // 인증 완료 (3명 이상)
}