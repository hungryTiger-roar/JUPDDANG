package com.jupddang.jupddang.account.service;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountLoginRequest;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AccountService implements UserDetailsService {

    private final AccountRepository accountRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    @Transactional
    public AccountResponse createAccount(AccountCreateRequest request) {

        if (accountRepository.existsById(request.getUserId())) {
            throw new IllegalArgumentException("UserId already exists.");
        }

        Account account = Account.builder()
                .userId(request.getUserId())
                .pw(bCryptPasswordEncoder.encode(request.getPw()))
                .email(request.getEmail())
                .nickname(request.getNickname())
                .region(request.getRegion())
                .color("#111111") // 블랙 (기본 값)
                .score(0)
                .build();

        return AccountResponse.from(accountRepository.save(account));
    }

    @Transactional(readOnly = true)
    public List<AccountResponse> getAllAccounts() {
        return accountRepository.findAll().stream()
                .map(AccountResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public AccountResponse login(AccountLoginRequest request) {
        Account account = accountRepository.findByUserId(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid userId or password."));

        if (!bCryptPasswordEncoder.matches(request.getPw(), account.getPw())) {
            throw new IllegalArgumentException("Invalid userId or password.");
        };

        return AccountResponse.from(account);
    }

    @Transactional(readOnly = true)
    public AccountResponse getAccount(String userId) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse updateAccount(String userId, AccountUpdateRequest request) {
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        account.update(
                bCryptPasswordEncoder.encode(request.getPw()),
                request.getNickname(),
                request.getProfileImage(),
                request.getIntro(),
                request.getRegion(),
                request.getEmail(),
                request.getColor()
                );

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse deleteAccount(String userId) {
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        accountRepository.delete(account);

        return AccountResponse.from(account);
    }


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return accountRepository.findByUserId(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
    }
}
