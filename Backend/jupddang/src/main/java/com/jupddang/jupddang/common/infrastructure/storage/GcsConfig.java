package com.jupddang.jupddang.common.infrastructure.storage;

import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class GcsConfig {

    @Bean
    public Storage gcsStorage() throws IOException {
        return StorageOptions.getDefaultInstance().getService();
    }
}