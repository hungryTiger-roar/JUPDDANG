package com.jupddang.jupddang.follow.controller;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.follow.dto.FollowResponse;
import com.jupddang.jupddang.follow.service.FollowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/follow")
@Tag(name = "follow api", description = "팔로우 관련 API")
public class FollowController {

    private final FollowService followService;

    @PostMapping("/{targetId}")
    @Operation(summary = "팔로우/언팔로우 토글", description = "이미 팔로우 상태면 언팔로우, 아니면 팔로우를 진행합니다.")
    public ResponseEntity<String> toggleFollow(
            @PathVariable String targetId,
            @Parameter(hidden = true) @AuthenticationPrincipal Account loginUser
    ) {
        // 현재 로그인한 유저의 ID와 대상을 서비스에 전달
        String result = followService.toggleFollow(loginUser.getUserId(), targetId);
        return ResponseEntity.ok(result);
    }
    @GetMapping("/followings/{userId}")
    @Operation(summary = "팔로잉 목록 조회", description = "특정 유저가 팔로우하는 유저 목록을 조회합니다.")
    public ResponseEntity<List<FollowResponse>> getFollowings(@PathVariable String userId) {
        return ResponseEntity.ok(followService.getFollowings(userId));
    }

    @GetMapping("/followers/{userId}")
    @Operation(summary = "팔로워 목록 조회", description = "특정 유저를 팔로우하는 유저 목록을 조회합니다.")
    public ResponseEntity<List<FollowResponse>> getFollowers(@PathVariable String userId) {
        return ResponseEntity.ok(followService.getFollowers(userId));
    }
}