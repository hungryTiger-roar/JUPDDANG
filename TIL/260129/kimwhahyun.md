# 📝 Today I Learned

**날짜:** 2026-01-30  
**작성자:** 김화현  
**주제:** Git Feature Branch 운영 및 충돌 없는 MR(Merge Request) 프로세스

---

## 1. Git 작업 정석 순서 (Feature → Target)
기능 개발 완료 후 메인 브랜치(또는 상위 브랜치)에 안전하게 합치기 위한 표준 절차입니다.

### [1단계] 로컬 작업 확정 및 푸시
현재 브랜치에서 작업한 내용을 기록하고 원격 저장소에 올립니다.

# 상태 확인
git status

# 변경 사항 스테이징 및 커밋
git add .
git commit -m "feat: 맵 화면 카메라 촬영 및 갤러리 저장 기능 추가"

# 원격 브랜치에 푸시
git push origin feature/camera

---

### [2단계] 타겟 브랜치와 동기화 (충돌 방지)
MR을 보내기 전, 타겟 브랜치(`front_community`)의 최신 내용을 가져와 현재 브랜치에 병합하여 충돌 여부를 미리 확인합니다.

# 타겟 브랜치 최신 정보 가져오기
git fetch origin front_community

# 현재 브랜치에 타겟 브랜치 병합
git merge origin/front_community

> **결과 확인:** `Already up to date`가 뜨면 충돌 없이 최신 상태가 반영된 것이므로 즉시 MR이 가능합니다.

---

### [3단계] 최종 푸시 및 MR 생성
병합 과정에서 변경 사항이 생겼다면 다시 푸시한 후, GitLab UI에서 MR을 생성합니다.

# 최종 푸시
git push origin feature/camera

---

## 2. GitLab Merge Request 작성 가이드
성공적인 코드 리뷰를 위해 MR 생성 시 다음 내용을 포함합니다.

- **Source:** `feature/camera` → **Target:** `front_community`
- **Title:** `[Feature] 맵 화면 카메라 촬영 및 갤러리 저장 기능 추가`
- **Description:**
  - 플로깅 중 카메라로 사진 촬영 기능 구현
  - 촬영한 사진 자동 갤러리 저장 기능 (Gal 패키지 활용)
  - `pubspec.yaml` 의존성 추가 사항 확인 필요

---

## 3. 주요 명령어 및 상태 요약

| 상황 | 관련 명령어 | 의미 |
| :--- | :--- | :--- |
| **Already up to date** | `git merge` 결과 | 현재 브랜치가 타겟 브랜치의 모든 내용을 이미 포함함 |
| **Everything up-to-date** | `git push` 결과 | 로컬의 커밋 내역이 원격 저장소와 완전히 일치함 |
| **Conflict (충돌)** | `git merge` 시 발생 | 같은 라인을 수정했을 때 발생하며, 수동 수정 후 다시 커밋 필요 |

---

## 💡 Insight
> **"Merge Request 전의 Merge 확인은 팀원에 대한 배려입니다."**
>
> 로컬에서 미리 `origin/target_branch`를 merge 해보는 습관은 코드 리뷰어의 부담을 줄이고, 배포 파이프라인의 중단을 막는 가장 확실한 방법입니다. `Already up to date`라는 메시지는 곧 '안전한 병합'을 의미하는 기분 좋은 신호입니다.