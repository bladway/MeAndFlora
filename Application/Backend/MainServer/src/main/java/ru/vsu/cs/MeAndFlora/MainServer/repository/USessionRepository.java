package ru.vsu.cs.MeAndFlora.MainServer.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ru.vsu.cs.MeAndFlora.MainServer.entity.USession;

@Repository
public interface USessionRepository extends JpaRepository<USession, Long> {
    List<USession> findByIpAddressAndIsClosed(String ipAddress, boolean isClosed);
}
