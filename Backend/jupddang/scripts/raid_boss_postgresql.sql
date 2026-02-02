-- =====================================================
-- PostgreSQL용 구미 지역 레이드 보스 테스트 데이터
-- 서버: https://i14d208.p.ssafy.io/dev-api
-- =====================================================

-- 1. 레이드 보스 5개 생성 (캠퍼스 중심 반경 1km 이내)
INSERT INTO raid_boss (h3_index, name) VALUES 
('8b2b90d2c94ffff', 'SSAFY_캠퍼스_보스'),
('8b2b90d2c92ffff', '금오산_입구_보스'),
('8b2b90d2c93ffff', '캠퍼스_북쪽_보스'),
('8b2b90d2c95ffff', '캠퍼스_동쪽_보스'),
('8b2b90d2c96ffff', '캠퍼스_남쪽_보스')
ON CONFLICT (h3_index) DO NOTHING;  -- PostgreSQL: 중복 시 무시

-- 보스 위치 정보:
-- 1. SSAFY_캠퍼스_보스 (8b2b90d2c94ffff): 36.109648, 128.417922 - 캠퍼스 바로 앞
-- 2. 금오산_입구_보스 (8b2b90d2c92ffff): 36.118, 128.422 - 북동쪽 약 1km
-- 3. 캠퍼스_북쪽_보스 (8b2b90d2c93ffff): 36.115, 128.418 - 북쪽 약 600m
-- 4. 캠퍼스_동쪽_보스 (8b2b90d2c95ffff): 36.110, 128.425 - 동쪽 약 500m
-- 5. 캠퍼스_남쪽_보스 (8b2b90d2c96ffff): 36.105, 128.416 - 남쪽 약 500m

-- =====================================================
-- 확인 쿼리
-- =====================================================
-- SELECT * FROM raid_boss ORDER BY id;
-- SELECT COUNT(*) FROM raid_boss;

-- =====================================================
-- 삭제 쿼리 (테스트 후 정리용)
-- =====================================================
-- DELETE FROM raid_record WHERE raid_boss_id IN (SELECT id FROM raid_boss WHERE name LIKE '%캠퍼스%' OR name LIKE '%금오산%');
-- DELETE FROM raid_boss WHERE name LIKE '%캠퍼스%' OR name LIKE '%금오산%';
