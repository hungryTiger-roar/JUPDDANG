# =====================================================
# PowerShell용 레이드 보스 생성 스크립트
# Windows에서 실행
# =====================================================

$API_URL = "https://i14d208.p.ssafy.io/dev-api"

Write-Host "🎯 레이드 보스 생성 시작..." -ForegroundColor Green
Write-Host ""

# 보스 1
Write-Host "1️⃣ SSAFY_캠퍼스_보스 생성 중..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "$API_URL/api/admin/raid/boss?h3Index=8b2b90d2c94ffff&name=SSAFY_캠퍼스_보스" -Method Post
Write-Host ""

# 보스 2
Write-Host "2️⃣ 금오산_입구_보스 생성 중..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "$API_URL/api/admin/raid/boss?h3Index=8b2b90d2c92ffff&name=금오산_입구_보스" -Method Post
Write-Host ""

# 보스 3
Write-Host "3️⃣ 캠퍼스_북쪽_보스 생성 중..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "$API_URL/api/admin/raid/boss?h3Index=8b2b90d2c93ffff&name=캠퍼스_북쪽_보스" -Method Post
Write-Host ""

# 보스 4
Write-Host "4️⃣ 캠퍼스_동쪽_보스 생성 중..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "$API_URL/api/admin/raid/boss?h3Index=8b2b90d2c95ffff&name=캠퍼스_동쪽_보스" -Method Post
Write-Host ""

# 보스 5
Write-Host "5️⃣ 캠퍼스_남쪽_보스 생성 중..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "$API_URL/api/admin/raid/boss?h3Index=8b2b90d2c96ffff&name=캠퍼스_남쪽_보스" -Method Post
Write-Host ""

Write-Host "✅ 레이드 보스 생성 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 확인: $API_URL/api/raid/bosses" -ForegroundColor Cyan
