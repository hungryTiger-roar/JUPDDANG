package com.jupddang.jupddang.plogging.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
@Table(name = "plogging_record")
public class PloggingRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plogging_record_id")
    private long id;
}
