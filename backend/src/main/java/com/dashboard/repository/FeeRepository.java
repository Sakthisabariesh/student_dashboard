package com.dashboard.repository;

import com.dashboard.model.FeeRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeeRepository extends JpaRepository<FeeRecord, Long> {
}
