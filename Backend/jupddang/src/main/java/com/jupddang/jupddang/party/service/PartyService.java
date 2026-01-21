package com.jupddang.jupddang.party.service;

import com.jupddang.jupddang.party.exception.InviteCodeGenerationException;
import com.jupddang.jupddang.party.repository.PartyRepository;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;

@Service
public class PartyService {

    private final PartyRepository partyRepository;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int CODE_LENGTH = 6;
    private static final int MAX_CODE_VALUE = 1_000_000;
    private static final int MAX_ATTEMPTS = 10;
    public PartyService(PartyRepository partyRepository) {
        this.partyRepository = partyRepository;
    }

    public String generateUniqueInviteCode() {
        int attempts = 0;

        while (attempts < MAX_ATTEMPTS) {
            String code = generateSixDigitCode();

            if (!partyRepository.existsByInviteCode(code)) {
                return code;
            }

            attempts++;
        }

        // RuntimeException 대신 커스텀 예외 던지기
        throw new InviteCodeGenerationException(
                "초대 코드 생성 실패: 최대 시도 횟수(" + MAX_ATTEMPTS + "회) 초과"
        );
    }

    private String generateSixDigitCode() {
        int code = RANDOM.nextInt(MAX_CODE_VALUE);
        return String.format("%0" + CODE_LENGTH + "d", code);
    }
}