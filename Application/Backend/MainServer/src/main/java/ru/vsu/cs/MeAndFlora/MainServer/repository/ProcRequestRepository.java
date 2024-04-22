package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;

@Repository
public interface ProcRequestRepository extends JpaRepository<ProcRequest, Long> {
    
}
