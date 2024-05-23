package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StatDto;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.AdvertisementView;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.time.OffsetDateTime;
import java.util.List;

@Repository
public interface AdvertisementViewRepository extends JpaRepository<AdvertisementView, Long> {

    List<AdvertisementView> findByCreatedTimeAfterAndSession(OffsetDateTime createdTime, USession session);

    List<AdvertisementView> findByCreatedTimeAfterAndSessionIn(OffsetDateTime createdTime, List<USession> sessionList);

    @Query(value =
            "SELECT new ru.vsu.cs.MeAndFlora.MainServer.controller.dto.StatDto"
                    + "(DATE_TRUNC('day', v.createdTime),COUNT(*)), DATE_TRUNC('day', v.createdTime) as day "
                    + "FROM AdvertisementView v WHERE v.createdTime BETWEEN ?1 AND ?2 "
                    + "GROUP BY DATE_TRUNC('day', v.createdTime)"
    )
    Page<StatDto> getAdvertisementPerDayInPeriod(OffsetDateTime startTime, OffsetDateTime endTime, Pageable pageable);

}