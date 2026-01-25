package com.jupddang.jupddang.sns.controller;

import com.jupddang.jupddang.sns.dto.CommentRequestDto;
import com.jupddang.jupddang.sns.dto.PostResponseDto;
import com.jupddang.jupddang.sns.service.SnsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/posts")
@Tag(name = "sns api", description = "SNS 관련 API")
public class SnsController {

    private final SnsService snsService;

    // 전체 포스트 조회
    @GetMapping
    @Operation(summary = "전체 게시글 조회")
    public ResponseEntity<List<PostResponseDto>> getAllPosts() {
        return ResponseEntity.ok(snsService.getAllPost());
    }

    // 포스트 좋아요
    @PostMapping("/{postId}/like")
    @Operation(summary = "게시글 좋아요")
    public ResponseEntity<String> likePost(@PathVariable Long postId) {
        snsService.like(postId);
        return ResponseEntity.ok("좋아요 성공");
    }

    // 포스트 삭제
    @DeleteMapping("/{postId}")
    @Operation(summary = "게시글 삭제")
    public ResponseEntity<String> deletePost(@PathVariable Long postId) {
        snsService.deletePost(postId);
        return ResponseEntity.ok("게시글 삭제 성공");
    }

    // 댓글 작성
    @PostMapping("/{postId}/comment")
    @Operation(summary = "댓글 작성")
    public ResponseEntity<Long> createComment(@PathVariable Long postId, @RequestBody CommentRequestDto requestDto) {
        Long commentId = snsService.createComment(postId, requestDto);
        return ResponseEntity.ok(commentId);
    }

    // 댓글 삭제
    @DeleteMapping("/{postId}/{commentId}")
    @Operation(summary = "댓글 삭제")
    public ResponseEntity<String> deleteComment(@PathVariable Long postId, @PathVariable Long commentId) {
        snsService.deleteComment(postId, commentId);
        return ResponseEntity.ok("댓글 삭제 성공");
    }
}
