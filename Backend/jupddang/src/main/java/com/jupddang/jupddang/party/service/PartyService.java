package com.jupddang.jupddang.party.service;

import com.jupddang.jupddang.party.repository.PartyRepository;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;

@Service
public class PartyService {

    private final PartyRepository partyRepository;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int CODE_LENGTH = 6;
    private static final int MAX_CODE_VALUE = 1_000_000; // 10^6
    private static final int MAX_ATTEMPTS = 10;

    public PartyService(PartyRepository partyRepository) {
        this.partyRepository = partyRepository;
    }

    /**
     * 중복되지 않는 6자리 초대 코드 생성
     * @return 6자리 숫자 문자열
     * @throws RuntimeException 최대 시도 횟수 초과 시
     */
    public String generateUniqueInviteCode() {
        int attempts = 0;

        while (attempts < MAX_ATTEMPTS) {
            String code = generateSixDigitCode();

            // 중복 체크
            if (!partyRepository.existsByInviteCode(code)) {
                return code;
            }

            attempts++;
        }

        throw new RuntimeException("초대 코드 생성 실패: 최대 시도 횟수 초과");
    }

    /**
     * 6자리 랜덤 숫자 코드 생성
     * @return 000000 ~ 999999 형식의 문자열
     */
    private String generateSixDigitCode() {
        int code = RANDOM.nextInt(MAX_CODE_VALUE); // 0 ~ 999999
        return String.format("%0" + CODE_LENGTH + "d", code);
    }
}
