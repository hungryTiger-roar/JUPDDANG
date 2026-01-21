package com.jupddang.jupddang.party.dto;
/**
 * 초대 코드 생성 API 응답 DTO
 * Record를 사용하여 불변 객체로 구현
 */
public record InviteCodeResponse (String inviteCode, String message){
    public InviteCodeResponse {
        if (inviteCode == null || inviteCode.isBlank()) {
            throw new IllegalArgumentException("초대 코드는 필수입니다.");
        }
        if (message == null || message.isBlank()) {
            throw new IllegalArgumentException("메시지는 필수입니다.");
        }
    }

    /**
     * 성공 응답 생성을 위한 정적 팩토리 메서드
     */
    public static InviteCodeResponse of(String inviteCode) {
        return new InviteCodeResponse(inviteCode, "초대 코드가 생성되었습니다.");
    }
}
