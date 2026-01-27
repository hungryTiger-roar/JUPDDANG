package com.jupddang.jupddang.trashcan.entity;

import com.jupddang.jupddang.account.entity.Account;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "trashcan_verifications",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_trashcan_user",
                        columnNames = {"trashcan_id", "user_id"}
                )
        }
)
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class TrashcanVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "trashcan_id", nullable = false)
    private Trashcan trashcan;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private Account user;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime verifiedAt;
}