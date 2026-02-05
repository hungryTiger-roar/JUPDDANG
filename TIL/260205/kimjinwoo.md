# TIL (Today I Learned)

## 2026-02-05(목)

---

# 정적 분석(Static Analysis)

---

분석 방식

소스 코드를 실행하지 않고 분석
AST(Abstract Syntax Tree) 기반 분석
패턴 매칭과 규칙 기반 검사


주요 도구

SonarQube
IntelliJ IDEA
기타 IDE 내장 분석 도구


장점

빠른 분석 속도 - 실행 없이 즉시 분석
신속한 피드백 - 개발 중 실시간 확인 가능
CI/CD 통합 - 파이프라인의 첫 단계에서 실행하여 품질 게이트 역할


AST(Abstract Syntax Tree)

표현식 노드와 문장 노드로 구성
코드 패턴 탐지와 복잡도 측정에 사용


주요 분석 영역
1. 코딩 스타일 및 컨벤션

일관된 코드 스타일 유지

2. 복잡도 측정

순환 복잡도(Cyclomatic Complexity)
인지 복잡도(Cognitive Complexity)

3. 보안 취약점 탐지

Arguments 안전성 확인
보안 위험 요소 식별

4. 버그 및 오류 탐지

잠재적 버그 사전 발견
런타임 오류 예방

5. 수정 방향 제시

문제점과 함께 개선 방안 제공