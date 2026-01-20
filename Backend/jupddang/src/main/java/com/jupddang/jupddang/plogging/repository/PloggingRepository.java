package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.domain.Plogging;

import java.util.List;
import java.util.Optional;

// TODO : JPA 적용
public interface PloggingRepository {
    Optional<Plogging> findById(Long id);
    Plogging save(Plogging session);
    void saveOccupiedLands(Long userId, List<String> gridIds);
}
