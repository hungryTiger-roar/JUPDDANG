package com.jupddang.jupddang.trashcan.entity;

import com.jupddang.jupddang.account.entity.Account;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "trashcans",
        indexes = {
                @Index(name = "idx_latitude_longitude", columnList = "latitude, longitude"),
                @Index(name = "idx_status", columnList = "status")
        }
)
public class Trashcan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(length = 500)
    private String address;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TrashcanStatus status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reported_by")
    private Account reportedBy;

    @Column(nullable = false)
    private Integer verificationCount = 0;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    protected Trashcan() {}

    public Long getId() {
        return id;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public TrashcanStatus getStatus() {
        return status;
    }

    public void setStatus(TrashcanStatus status) {
        this.status = status;
    }

    public Account getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(Account reportedBy) {
        this.reportedBy = reportedBy;
    }

    public Integer getVerificationCount() {
        return verificationCount;
    }

    public void setVerificationCount(Integer verificationCount) {
        this.verificationCount = verificationCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}