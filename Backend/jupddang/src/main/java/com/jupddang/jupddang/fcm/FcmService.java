package com.jupddang.jupddang.fcm;

import com.google.firebase.messaging.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class FcmService {

    private final FcmTokenRepository fcmTokenRepository;

    /**
     * FCM 토큰 저장/업데이트
     */
    @Transactional
    public void saveToken(FcmTokenRequest request, String userId) {

        FcmToken fcmToken = fcmTokenRepository
                .findByUserIdAndDeviceType(userId, request.getDeviceType())
                .orElse(null);

        if (fcmToken == null) {
            // 신규 토큰 등록
            fcmToken = FcmToken.builder()
                    .userId(userId)
                    .token(request.getToken())
                    .deviceType(request.getDeviceType())
                    .build();

            fcmTokenRepository.save(fcmToken);
            log.info("FCM 토큰 신규 등록: userId={}, deviceType={}",
                    userId, request.getDeviceType());

        } else if (!request.getToken().equals(fcmToken.getToken())) {

            // 토큰 변경 시에만 업데이트
            fcmToken.updateToken(request.getToken());

            log.info("FCM 토큰 변경: userId={}, deviceType={}",
                    userId, request.getDeviceType());

        } else {
            // 토큰 동일 - 아무것도 안 함
            log.info("FCM 토큰 동일 (업데이트 스킵): userId={}", userId);
        }

    }

    /**
     * 특정 사용자에게 알림 전송
     */
    public void sendNotificationToUser(String userId, String title, String body, Map<String, String> data) {
        List<FcmToken> tokens = fcmTokenRepository.findByUserId(userId);

        if (tokens.isEmpty()) {
            log.warn("사용자의 FCM 토큰이 없습니다: userId={}", userId);
            return;
        }

        for (FcmToken fcmToken : tokens) {
            sendNotification(fcmToken.getToken(), title, body, data);
        }

    }

    /**
     * 단일 토큰으로 알림 전송
     */
    private void sendNotification(String token, String title, String body, Map<String, String> data) {
        try {
            // 알림 메시지 구성
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            // 데이터 메시지 구성 (선택사항)
            Map<String, String> dataMap = data != null ? data : new HashMap<>();

            // 메시지 빌드
            Message message = Message.builder()
                    .setToken(token)
                    .setNotification(notification)
                    .putAllData(dataMap)
                    .setAndroidConfig(AndroidConfig.builder()
                            .setPriority(AndroidConfig.Priority.HIGH)
                            .setNotification(AndroidNotification.builder()
                                    .setSound("default")
                                    .setColor("#FF6B35")
                                    .build())
                            .build())
                    .setApnsConfig(ApnsConfig.builder()
                            .setAps(Aps.builder()
                                    .setSound("default")
                                    .build())
                            .build())
                    .build();

            // FCM 전송
            String response = FirebaseMessaging.getInstance().send(message);
            log.info("FCM 알림 전송 성공: response={}", response);

        } catch (FirebaseMessagingException e) {
            log.error("FCM 알림 전송 실패: token={}, error={}", token, e.getMessage());

        }
    }

    /**
     * 플로깅 완료 알림
     */
    public void sendPloggingCompletedNotification(
            String userId,
            String recordTitle,
            double distance,
            int times,
            int score,
            LocalDateTime completedAt) {

        Map<String, String> data = new HashMap<>();
        data.put("type", "PLOGGING_COMPLETED");
        data.put("recordTitle", recordTitle);
        data.put("distance", String.valueOf(distance));
        data.put("times", String.valueOf(times));
        data.put("score", String.valueOf(score));

        String title = "오늘의 플로깅 완료!";

        // 거리 포맷 (km)
        String distanceText = String.format("%.2fkm", distance / 1000.0);

        // 시간 포맷 (60초 미만: 초, 60초 이상: 분초)
        String timeText;
        if (times < 60) {
            timeText = times + "초";
        } else {
            int minutes = times / 60;
            int seconds = times % 60;
            if (seconds > 0) {
                timeText = minutes + "분 " + seconds + "초";
            } else {
                timeText = minutes + "분";
            }
        }

        // 점수 포맷
        String scoreText = score + "점";

        // 완료 시간 포맷
        String completedTimeText = formatCompletedDate(completedAt);

        // 한 줄로 표시
        String body = distanceText + " · " + timeText + " · " + scoreText + " · " + completedTimeText;

        sendNotificationToUser(userId, title, body, data);
    }

    /**
     * 댓글 알림
     */
    public void sendCommentNotification(String targetUserId, String commenterName, Long postId, String commentPreview) {
        Map<String, String> data = new HashMap<>();
        data.put("type", "NEW_COMMENT");
        data.put("postId", String.valueOf(postId));

        String title = commenterName + "님이 내 게시글에 댓글을 남겼습니다";
        String body = commentPreview;  // 댓글 내용

        sendNotificationToUser(targetUserId, title, body, data);
    }

    /**
     * 완료 날짜 포맷팅
     */
    private String formatCompletedDate(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH:mm");
        return dateTime.format(formatter);
    }

    @Transactional
    public void logout(String userId) {

        // FCM 토큰 제거
        fcmTokenRepository.deleteByUserId(userId);

    }

}
