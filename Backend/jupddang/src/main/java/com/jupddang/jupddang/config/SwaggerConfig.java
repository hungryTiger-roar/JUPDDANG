package com.jupddang.jupddang.config;

import com.jupddang.jupddang.account.entity.Account;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.utils.SpringDocUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class SwaggerConfig {

    // [필수] Account 엔티티 500 에러 방지
    static {
        SpringDocUtils.getConfig().addRequestWrapperToIgnore(Account.class);
    }

    @Value("${jupddang.domain-url:https://i14d208.p.ssafy.io}")
    private String domainUrl;

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info().title("Jupddang API").version("v1.0"))
                .servers(List.of(
                        // [핵심] Nginx의 /dev-api 경로를 명시
                        new Server().url(domainUrl + "/dev-api").description("Development Server"),
                        new Server().url("http://localhost:8080").description("Local Server")
                ))
                .addSecurityItem(new SecurityRequirement().addList("JWT"))
                .components(new io.swagger.v3.oas.models.Components()
                        .addSecuritySchemes("JWT",
                                new SecurityScheme()
                                        .name("Authorization")
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                        )
                );
    }
}