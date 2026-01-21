# 김강연 Today I Learned

---

## 1월 20일

## 1. 사용 이유 (Why?)

* **버전 관리 (History):** "최종.txt", "진짜최종.txt"의 늪에서 탈출. 언제든 과거의 특정 시점으로 코드를 되돌릴 수 있다.
* **협업 (Collaboration):** 여러 개발자가 동시에 같은 프로젝트를 작업해도 코드를 병합(Merge)하고 충돌(Conflict)을 체계적으로 해결할 수 있다.
* **백업 (Backup):** 로컬 컴퓨터에 문제가 생겨도 원격 저장소(Remote Repository)에 코드가 안전하게 보관된다.

## 2. 핵심 사용법 (How?)

개발 과정에서 가장 빈번하게 사용하는 필수 루틴 5단계:

1.  `git init` / `git clone [url]`
    * 프로젝트를 시작하거나 기존 저장소를 내 컴퓨터로 가져오기.
2.  `git pull origin [branch]`
    * 작업 시작 전, 원격 저장소의 최신 변경 사항을 먼저 당겨오기 (충돌 방지).
3.  `git add .`
    * 변경된 파일들을 스테이징 영역(Staging Area, 장바구니)에 담기.
4.  `git commit -m "feat: 로그인 기능 구현"`
    * 변경 사항을 확정 짓고 의미 있는 메시지와 함께 기록 남기기.
5.  `git push origin [branch]`
    * 내 로컬의 기록을 원격 저장소로 업로드하기.

## 3. 브랜치 전략 (Strategy)

협업 시 코드가 꼬이지 않게 하는 약속. 입문자에게는 가장 명확한 **Feature Branch Workflow**를 권장한다.

* **Main (Master):** 언제나 배포 가능한 깨끗한 상태(Production Ready)를 유지한다. 절대 직접 `push` 하지 않는다.
* **Feature Branches:** `main`에서 브랜치를 따서 개별 기능을 개발한다.
    * 예: `feat/login-api`, `fix/header-style`
* **PR (Pull Request):** 기능 개발이 완료되면 `main` 브랜치로 병합 요청을 보내고, 코드 리뷰(Code Review)를 거쳐 병합한다.