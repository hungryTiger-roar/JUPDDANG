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
    @GetMapping("/all")
    @Operation(summary = "전체 게시글 조회")
    public ResponseEntity<List<PostResponseDto>> getAllPosts() {
        return ResponseEntity.ok(snsService.getAllPost());
    }

    @GetMapping
    @Operation(summary = "팔로잉 피드 조회", description = "내가 팔로우하는 유저들과 내 게시글을 최신순으로 조회합니다.")
    public ResponseEntity<List<PostResponseDto>> getFollowFeed(
            // Swagger에서 Account 객체가 노출되지 않게 숨김 처리하며 인증 객체를 주입받습니다.
            @io.swagger.v3.oas.annotations.Parameter(hidden = true)
            @org.springframework.security.core.annotation.AuthenticationPrincipal
            com.jupddang.jupddang.account.entity.Account loginUser
    ) {
        // [수정] 서비스의 신규 메서드 호출
        return ResponseEntity.ok(snsService.getFollowFeed(loginUser));
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
