package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.AdvertisementView;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.ProcRequest;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.time.OffsetDateTime;
import java.util.List;

@Repository
public interface AdvertisementViewRepository extends JpaRepository<AdvertisementView, Long> {

    List<AdvertisementView> findByCreatedTimeAfterAndSession(OffsetDateTime createdTime, USession session);

    List<AdvertisementView> findByCreatedTimeAfterAndSessionIn(OffsetDateTime createdTime, List<USession> sessionList);

    List<AdvertisementView> findByCreatedTimeBetween(OffsetDateTime startTime, OffsetDateTime endTime);

}