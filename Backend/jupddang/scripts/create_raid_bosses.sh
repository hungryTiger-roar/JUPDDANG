#!/bin/bash

# =====================================================
# 구미 지역 레이드 보스 생성 스크립트
# API를 통한 자동 생성 (가장 간단한 방법)
# =====================================================

API_URL="https://i14d208.p.ssafy.io/dev-api"

echo "🎯 레이드 보스 생성 시작..."
echo ""

# 보스 1: SSAFY 캠퍼스
echo "1️⃣ SSAFY_캠퍼스_보스 생성 중..."
curl -X POST "${API_URL}/api/admin/raid/boss?h3Index=8b2b90d2c94ffff&name=SSAFY_캠퍼스_보스"
echo ""
echo ""

# 보스 2: 금오산 입구
echo "2️⃣ 금오산_입구_보스 생성 중..."
curl -X POST "${API_URL}/api/admin/raid/boss?h3Index=8b2b90d2c92ffff&name=금오산_입구_보스"
echo ""
echo ""

# 보스 3: 캠퍼스 북쪽
echo "3️⃣ 캠퍼스_북쪽_보스 생성 중..."
curl -X POST "${API_URL}/api/admin/raid/boss?h3Index=8b2b90d2c93ffff&name=캠퍼스_북쪽_보스"
echo ""
echo ""

# 보스 4: 캠퍼스 동쪽
echo "4️⃣ 캠퍼스_동쪽_보스 생성 중..."
curl -X POST "${API_URL}/api/admin/raid/boss?h3Index=8b2b90d2c95ffff&name=캠퍼스_동쪽_보스"
echo ""
echo ""

# 보스 5: 캠퍼스 남쪽
echo "5️⃣ 캠퍼스_남쪽_보스 생성 중..."
curl -X POST "${API_URL}/api/admin/raid/boss?h3Index=8b2b90d2c96ffff&name=캠퍼스_남쪽_보스"
echo ""
echo ""

echo "✅ 레이드 보스 생성 완료!"
echo ""
echo "📋 확인: ${API_URL}/api/raid/bosses"
