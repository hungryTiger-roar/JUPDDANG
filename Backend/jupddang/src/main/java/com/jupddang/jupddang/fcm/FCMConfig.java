package com.jupddang.jupddang.fcm;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.FileNotFoundException;
import java.io.IOException;

@Configuration
public class FCMConfig {

    @org.springframework.beans.factory.annotation.Value("${firebase.config.path:}")
    private String firebaseConfigPath;

    @PostConstruct
    public void initialize() throws IOException {
        java.io.InputStream serviceAccount = null;

        // 1. 외부 설정 파일 경로가 지정되어 있고 파일이 존재하면 사용
        if (org.springframework.util.StringUtils.hasText(firebaseConfigPath)) {
            java.io.File file = new java.io.File(firebaseConfigPath);
            if (file.exists()) {
                serviceAccount = new java.io.FileInputStream(file);
                System.out.println("Firebase 설정 로드 (외부 파일): " + firebaseConfigPath);
            }
        }

        // 2. 외부 파일이 없으면 Classpath 리소스 사용
        if (serviceAccount == null) {
            ClassPathResource resource = new ClassPathResource(
                    "fcm/jupddang-f0415-firebase-adminsdk-fbsvc-03245914b8.json");
            if (resource.exists()) {
                serviceAccount = resource.getInputStream();
                System.out.println(
                        "Firebase 설정 로드 (Classpath): fcm/jupddang-f0415-firebase-adminsdk-fbsvc-03245914b8.json");
            }
        }

        if (serviceAccount == null) {
            throw new FileNotFoundException("Firebase 서비스 계정 파일을 찾을 수 없습니다");
        }

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(options);
            System.out.println("Firebase 초기화 성공!");
        }
    }

}
