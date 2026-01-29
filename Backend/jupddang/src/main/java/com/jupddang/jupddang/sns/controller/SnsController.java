package com.jupddang.jupddang.sns.controller;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.sns.dto.CommentRequestDto;
import com.jupddang.jupddang.sns.dto.MyCommentResponseDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.sns.dto.PostCreateRequest;
import com.jupddang.jupddang.sns.dto.PostResponseDto;
import com.jupddang.jupddang.sns.entity.Comment;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.service.SnsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/posts")
@Tag(name = "sns api", description = "SNS 관련 API")
public class SnsController {

    private final SnsService snsService;
    private final ObjectMapper objectMapper;

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

    // 내가 작성한 피드 확인
    @GetMapping("myposts")
    @Operation(summary = "내가 작성한 피드 확인")
    public ResponseEntity<List<PostResponseDto>> getMyPosts(@AuthenticationPrincipal Account account) {
        List<PostResponseDto> getPosts = snsService.getMyPosts(account.getUserId());
        return ResponseEntity.ok(getPosts);
    }

    // 내가 작성한 댓글 확인
    @GetMapping("mycomments")
    @Operation(summary = "내가 작성한 댓글 확인")
    public ResponseEntity<List<MyCommentResponseDto>> getMyComments(@AuthenticationPrincipal Account account) {
        List<MyCommentResponseDto> getPosts = snsService.getMyComments(account.getUserId());
        return ResponseEntity.ok(getPosts);
    }

    /**
     * 일반 게시글 작성 (Before, After, Map 이미지 포함)
     * POST /api/posts
     */
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "일반 게시글 작성", description = "플로깅 없이 사진(Before, After, Map)과 글로 게시글을 작성합니다.")
    public ResponseEntity<String> createPost(
            @RequestPart("data") String dataJson,
            @RequestPart(value = "beforeImage", required = false) MultipartFile beforeImage,
            @RequestPart(value = "afterImage", required = false) MultipartFile afterImage,
            @RequestPart(value = "mapImage", required = false) MultipartFile mapImage,
            @io.swagger.v3.oas.annotations.Parameter(hidden = true)
            @org.springframework.security.core.annotation.AuthenticationPrincipal
            com.jupddang.jupddang.account.entity.Account loginUser
    ) throws Exception {

        // 1. JSON String을 DTO로 변환
        PostCreateRequest request = objectMapper.readValue(dataJson, PostCreateRequest.class);

        // 2. 서비스 호출 (이미지들을 전달)
        // [주의] SnsService에 createPost 메서드가 없으면 여기서 계속 에러가 납니다.
        Long postId = snsService.createPost(loginUser, request, beforeImage, afterImage, mapImage);

        return ResponseEntity.ok("게시글 작성 완료: " + postId);
    }
    
}
