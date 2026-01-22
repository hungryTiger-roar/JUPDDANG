# 김강연 Today I Learned

---

## 1월 22일

## 이미 Push된 Merge Commit 취소하기 (feat. revert)

### 1. 문제 상황
* 원격 저장소(`origin/master`)에 이미 올라간 **Merge Commit**(`0b7d952`)을 취소해야 함.
* **난관:** 취소하려는 머지 커밋 바로 위에 **이미 새로운 커밋**(`2aa9722`)이 쌓여 있음.
* 단순 `reset`을 하면 최신 커밋(`2aa9722`)까지 날아가 버리는 상황.

### 2. 해결 방법: `git revert` 사용 (권장)
가장 안전한 방법은 `revert`를 사용하여 **"머지했던 동작만 반대로 수행하는 새로운 커밋"**을 만드는 것이다.

### 명령어
```bash
# 문법: git revert -m 1 [취소할_머지_커밋_해시]
git revert -m 1 0b7d952