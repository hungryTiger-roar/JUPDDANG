package com.jupddang.jupddang.common.infrastructure.storage;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;

@Configuration
public class GcsConfig {

    @Bean
    public Storage gcsStorage() throws IOException {
        // JSON 파일에서 credentials 로드
        GoogleCredentials credentials = GoogleCredentials
                .fromStream(new ClassPathResource("gcp-credentials.json").getInputStream());

        // 명시적으로 credentials와 project-id 설정
        return StorageOptions.newBuilder()
                .setCredentials(credentials)
                .setProjectId("jupddang")
                .build()
                .getService();
    }
}