**- Transformer**
    - Self-Attention 기반으로 시퀀스(문장)안의 토큰들간 관계를 병렬로 학습하는 딥러닝 모델 아키텍처
    - NLP(자연어 처리)에서 표준이 됐고, 지금은 비전/음성/멀티모달까지 범용으로 확장
    - BERT : Encoder기반 (이해/분류)
    - GPT : Decoder 기반 (생성)
    - T5/BART : Encoder/Decoder 기반 (변환/요약/번역)
    - 
**- MCP(Model Context Protocol)**
    - AI가 외부 도구/데이터(파일, DB, 사내시스템 등)를 표준화된 방식으로 안전하게 연결해서 쓸 수 있게 해주는 연결 규격(프로토콜)
    - Host : MCP를 통해서 데이터에 접근하려는 주체 (Claude, ChatGPT, IDEs 등)
    - MCP Client : 호스트안에서 서버와 1:1 연결을 유지
    - MCP Server : MCP Client의 요청을 받아서 정보를 제공하거나 동작을 실행(깃허브, 구글 드라이브, DB, 파일 등)
    - Host → MCP Client → MCP Server → Resource / Tool
    
**- RAG (Retrieval Argumented Generation, 검색 증강 생성)**
    - LLM이 답을 모델 파라미터에서만 만들지 않고 외부 문서/DB에서 관련 근거를 먼저 찾아 (Retrieval) 그 근거를 보고 답을 생성
    - LLM의 한계인 학습 시점 이후 정보(최신성/변경된 정책/새 문서)는 모른다는 문제와 환각 문제 완화
    - Retrieval (검색)
        - 문서를 잘게 쪼갬(Chunking)
        - 각 Chunk를 Embedding 벡터로 변환
            - 의미를 숫자 벡터로 만든 것
        - 벡터를 벡터 DB에 저장
        - 사용자가 질문하면 질문을 embedding으로 변환
        - 벡터 DB에서 유사한 chunk top-k 찾음
            - 의미가 가까운 문서 조각 검색
    - Generation(생성)
        - 벡터 DB에서 찾은 Chunk를 프롬프트에 넣고 LLM에게 요청
        - LLM이 근거를 기반으로 답변 생성