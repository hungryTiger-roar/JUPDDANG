-- =====================================================
-- 구미 지역 레이드 보스 테스트 데이터
-- 중심 위치: 36.109648, 128.417922 (SSAFY 구미 캠퍼스)
-- H3 Resolution: 11 (약 25m × 25m 그리드)
-- =====================================================

-- 레이드 보스 5개 생성 (캠퍼스 중심 반경 1km 이내)
INSERT INTO raid_boss (h3_index, name) VALUES 
('8b2b90d2c94ffff', 'SSAFY_캠퍼스_보스'),
('8b2b90d2c92ffff', '금오산_입구_보스'),
('8b2b90d2c93ffff', '캠퍼스_북쪽_보스'),
('8b2b90d2c95ffff', '캠퍼스_동쪽_보스'),
('8b2b90d2c96ffff', '캠퍼스_남쪽_보스');

-- 보스 위치 정보:
-- 1. SSAFY_캠퍼스_보스 (8b2b90d2c94ffff): 36.109648, 128.417922 - 캠퍼스 바로 앞
-- 2. 금오산_입구_보스 (8b2b90d2c92ffff): 36.118, 128.422 - 북동쪽 약 1km, 금오산 둘레길
-- 3. 캠퍼스_북쪽_보스 (8b2b90d2c93ffff): 36.115, 128.418 - 북쪽 약 600m, 산책로
-- 4. 캠퍼스_동쪽_보스 (8b2b90d2c95ffff): 36.110, 128.425 - 동쪽 약 500m, 주거지역
-- 5. 캠퍼스_남쪽_보스 (8b2b90d2c96ffff): 36.105, 128.416 - 남쪽 약 500m, 공원

-- =====================================================
-- 테스트용 사용자 데이터
-- =====================================================
INSERT INTO account (user_id, email, nickname, pw, color, total_score, total_distance, total_time, tier, created_at) VALUES
('test_user1', 'test1@ssafy.com', '테스트유저1', '$2a$10$dummyencryptedpassword', '#FF5733', 0, 0.0, 0, '새싹', NOW()),
('test_user2', 'test2@ssafy.com', '테스트유저2', '$2a$10$dummyencryptedpassword', '#33FF57', 0, 0.0, 0, '새싹', NOW()),
('test_user3', 'test3@ssafy.com', '테스트유저3', '$2a$10$dummyencryptedpassword', '#3357FF', 0, 0.0, 0, '새싹', NOW());

-- =====================================================
-- 테스트용 레이드 기록 (선택사항)
-- =====================================================
-- 보스 ID는 실제 생성된 ID로 변경 필요
-- INSERT INTO raid_record (raid_boss_id, account_user_id, total_score, updated_at) VALUES
-- (1, 'test_user1', 1500, NOW()),
-- (1, 'test_user2', 2000, NOW()),
-- (2, 'test_user3', 1000, NOW());

-- =====================================================
-- 확인 쿼리
-- =====================================================
-- SELECT * FROM raid_boss;
-- SELECT * FROM account WHERE user_id LIKE 'test_%';
-- SELECT * FROM raid_record;

-- =====================================================
-- 삭제 쿼리 (테스트 후 정리용)
-- =====================================================
-- DELETE FROM raid_record WHERE raid_boss_id IN (SELECT id FROM raid_boss WHERE name LIKE '%캠퍼스%');
-- DELETE FROM raid_boss WHERE name LIKE '%캠퍼스%' OR name LIKE '%금오산%';
-- DELETE FROM account WHERE user_id LIKE 'test_%';
