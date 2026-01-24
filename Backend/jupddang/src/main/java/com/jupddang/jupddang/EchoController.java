package com.jupddang.jupddang;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class EchoController {

    // 클라이언트가 "/pub/echo"로 메시지를 보내면 여기로 들어옴
    @MessageMapping("/echo")
    // 처리 후 "/sub/channel/echo"를 구독 중인 사용자들에게 반환
    @SendTo("/sub/channel/echo")
    public EchoDto echoMessage(EchoDto message) {
        System.out.println("수신된 메시지: " + message.getContent());

        // 받은 내용 뒤에 [Echo] 붙여서 리턴
        return new EchoDto("Server Echo: " + message.getContent());
    }

    // 테스트용 DTO
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class EchoDto {
        private String content;
    }
}