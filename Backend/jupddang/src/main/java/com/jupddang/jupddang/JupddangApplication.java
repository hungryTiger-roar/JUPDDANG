package com.jupddang.jupddang;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class JupddangApplication {

    public static void main(String[] args) {
        SpringApplication.run(JupddangApplication.class, args);
    }

}
