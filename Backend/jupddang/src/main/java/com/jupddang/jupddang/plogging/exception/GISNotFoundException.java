package com.jupddang.jupddang.plogging.exception;

public class GISNotFoundException extends PloggingException {
    // 생성자에서 구체적인 에러 코드를 부모에게 넘겨줍니다.
    public GISNotFoundException() {
        super(PloggingErrorCode.GIS_NOT_FOUND);
    }
}
