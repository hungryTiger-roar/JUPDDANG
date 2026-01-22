package com.jupddang.jupddang.account.repository;

import com.jupddang.jupddang.account.entity.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, String> {

    Optional<Account> findByUserId(String userId);

    Optional<Account> findByUserIdAndPw(String userId, String pw);
}
