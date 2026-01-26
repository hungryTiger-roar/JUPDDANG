package com.jupddang.jupddang.common.infrastructure.storage;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource; // 중요!

import java.io.IOException;

@Configuration
public class GcsConfig {


    @Value("${spring.cloud.gcp.credentials.location}")
    private Resource gcpCredentialResource;

    @Value("${spring.cloud.gcp.project-id}")
    private String projectId;

    @Bean
    public Storage gcsStorage() throws IOException {
        // 주입받은 Resource에서 Stream을 바로 꺼냅니다.
        GoogleCredentials credentials = GoogleCredentials
                .fromStream(gcpCredentialResource.getInputStream());

        return StorageOptions.newBuilder()
                .setCredentials(credentials)
                .setProjectId(projectId)
                .build()
                .getService();
    }
}