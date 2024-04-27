package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.USession;

import java.util.Optional;

@Repository
public interface USessionRepository extends JpaRepository<USession, Long> {

    Optional<USession> findByJwt(String jwt);

    Optional<USession> findByJwtR(String jwtR);

}
