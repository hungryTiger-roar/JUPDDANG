package com.jupddang.jupddang.sns.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.sns.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findAllByOrderByCreatedAtDesc();
    Optional<Post> findByPloggingId(Long ploggingId);
    List<Post> findAllByAccountInOrderByCreatedAtDesc(List<Account> accounts);

}
