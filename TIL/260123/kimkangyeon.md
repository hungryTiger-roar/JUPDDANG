# 김강연 Today I Learned

---

## 1월 23일

## 1. 문제 상황
* 방금 작성한 커밋(`HEAD`)이 아니라, **그보다 더 전에 작성한 커밋(예: 2번째 전)**의 메시지를 수정하고 싶음.
* 단순 `git commit --amend`는 가장 최신 커밋만 수정 가능하므로 사용할 수 없음.

## 2. 해결 방법: `git rebase -i`

1) Rebase 모드 진입 (수정할 커밋이 포함된 범위 지정)

```bash
# 예: 최근 2개의 커밋을 불러옴
git rebase -i HEAD~2
```

2) 명령어 변경 (pick -> reword)

에디터가 열리면 수정하고 싶은 커밋 앞의 pick을 reword (또는 r)로 변경.

주의: 커밋 순서가 오래된 순 -> 최신 순으로 정렬되어 있음.

```bash
reword 1cac971 [S14P11D208-92] feat: Feed 엔티티 및 Repository 구현 #done
pick 21dfb9a [S14P11D208-93] feat: Feed 생성 API 구현 #done
```

3) 메시지 수정
저장하고 닫으면(4:wq), 해당 커밋의 메시지를 수정할 수 있는 새 창이 뜸.
원하는 메시지로 변경 후 저장.

## 3. 핵심 요약
- pick: 커밋을 그대로 사용함.
- reword: 커밋 내용은 그대로 두고, 메시지만 수정함.
- edit: 커밋 내용을 수정함 (파일 변경 등).

## 4. 주의사항
아직 원격 저장소(origin)에 Push하기 전이라면 자유롭게 수정 가능.
만약 이미 Push를 한 상태라면, 로컬에서 수정 후 git push -f origin <branch>로 덮어씌워야 함 (협업 시 주의).