package com.jupddang.jupddang.sns.repository;

import com.jupddang.jupddang.sns.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    // 내가 작성한 댓글 확인용
    List<Comment> findByAccount_UserId(String userId);
}
