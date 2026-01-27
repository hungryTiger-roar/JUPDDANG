package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.domain.Plogging;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;


public interface PloggingRepository  extends JpaRepository<Plogging, String> {
}
