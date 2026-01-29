package com.jupddang.jupddang.sns.service;

import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.follow.repository.FollowRepository;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.sns.dto.CommentRequestDto;
import com.jupddang.jupddang.sns.dto.PostCreateRequestDto;
import com.jupddang.jupddang.sns.dto.PostResponseDto;
import com.jupddang.jupddang.sns.entity.Comment;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.CommentRepository;
import com.jupddang.jupddang.sns.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SnsService {
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;
    private final GcsImageService gcsImageService;
    private final AccountRepository accountRepository;
    private final FollowRepository followRepository;

    /**
     * [수정됨] Plogging 완료 이벤트 처리
     * 이미 PloggingServiceImpl에서 업로드와 Post 생성을 마쳤으므로
     * 여기서는 중복 로직을 제거하고 로그만 남기거나, 알림 전송 로직만 남깁니다.
     */
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        // 중복 로직(업로드, 저장) 삭제함
        log.info("PloggingCompletedEvent 수신 완료 (Post 생성은 앞단에서 처리됨) - ploggingId: {}", event.ploggingId());

    }

    @Transactional(readOnly = true)
    public List<PostResponseDto> getFollowFeed(Account loginUser) {
        // 1. 내가 팔로우하는 대상들을 가져옴
        List<Account> followingAccounts = followRepository.findAllByFollower(loginUser).stream()
                .map(follow -> follow.getFollowing())
                .collect(Collectors.toList());

        // 2. (선택사항) 내 글도 피드에 포함하고 싶다면 나를 리스트에 추가
        followingAccounts.add(loginUser);

        // 3. 팔로잉 중인 유저들의 글만 조회
        return postRepository.findAllByAccountInOrderByCreatedAtDesc(followingAccounts).stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }
    // 전체 포스트 조회
    @Transactional
    public PostResponseDto createPost(PostCreateRequestDto request) {
        return createPostInternal(request, List.of());
    }

    @Transactional
    public PostResponseDto createPostWithImages(
            PostCreateRequestDto request,
            List<MultipartFile> images
    ) {
        return createPostInternal(request, images);
    }

    private PostResponseDto createPostInternal(
            PostCreateRequestDto request,
            List<MultipartFile> images
    ) {
        Account account = accountRepository.findByUserId(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        List<String> uploadedUrls = new ArrayList<>();
        if (images != null) {
            for (MultipartFile image : images) {
                if (image == null || image.isEmpty()) {
                    continue;
                }
                uploadedUrls.add(gcsImageService.uploadImage(image, "community"));
                if (uploadedUrls.size() >= 3) {
                    break;
                }
            }
        }

        String beforeImageUrl = request.getBeforeImageUrl();
        String afterImageUrl = request.getAfterImageUrl();
        String mapImageUrl = request.getMapImageUrl();

        if (!uploadedUrls.isEmpty()) {
            beforeImageUrl = uploadedUrls.get(0);
        }
        if (uploadedUrls.size() > 1) {
            afterImageUrl = uploadedUrls.get(1);
        }
        if (uploadedUrls.size() > 2) {
            mapImageUrl = uploadedUrls.get(2);
        }

        Post post = Post.builder()
                .account(account)
                .content(request.getContent())
                .beforeImageUrl(beforeImageUrl)
                .afterImageUrl(afterImageUrl)
                .mapImageUrl(mapImageUrl)
                .build();

        return new PostResponseDto(postRepository.save(post));
    }

    @Transactional(readOnly = true)
    public List<PostResponseDto> getAllPost() {
        return postRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }

    // 포스트 좋아요
    @Transactional
    public void like(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException(postId + " 해당 게시글이 없습니다."));
        post.increaseLike();
    }

    // 포스트 삭제
    @Transactional
    public void deletePost(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        // 삭제는 여기서 하는게 맞습니다 (Post가 삭제될 때 이미지도 지워야 하니까)
        gcsImageService.deleteImage(post.getBeforeImageUrl());
        gcsImageService.deleteImage(post.getAfterImageUrl());
        gcsImageService.deleteImage(post.getMapImageUrl());

        postRepository.delete(post);
    }

    // 댓글 작성
    @Transactional
    public Long createComment(Long postId, CommentRequestDto requestDto) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다. id=" + postId));

        Account account = accountRepository.findById(requestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("해당 유저가 없습니다."));

        Comment comment = Comment.builder()
                .post(post)
                .account(account)
                .content(requestDto.getContent())
                .build();

        return commentRepository.save(comment).getCommentId();
    }

    // 댓글 삭제
    @Transactional
    public void deleteComment(Long postId, Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다. id=" + commentId));

        if (!comment.getPost().getPostId().equals(postId)) {
            throw new IllegalArgumentException("해당 게시글의 댓글이 아닙니다.");
        }

        commentRepository.delete(comment);
    }


}