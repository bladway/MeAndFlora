package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.time.OffsetDateTime;
import java.util.List;

@Repository
public interface ProcRequestRepository extends JpaRepository<ProcRequest, Long> {

    List<ProcRequest> findByCreatedTimeAfterAndSession(OffsetDateTime createdTime, USession session);

    List<ProcRequest> findByCreatedTimeAfterAndSessionIn(OffsetDateTime createdTime, List<USession> sessionList);

    List<ProcRequest> findByCreatedTimeBetween(OffsetDateTime startTime, OffsetDateTime endTime);

    Page<ProcRequest> findByFloraIn(List<Flora> floraList, Pageable pageable);

    Page<ProcRequest> findByStatus(String status, Pageable pageable);

    Page<ProcRequest> findBySessionIn(List<USession> sessionList, Pageable pageable);

}
