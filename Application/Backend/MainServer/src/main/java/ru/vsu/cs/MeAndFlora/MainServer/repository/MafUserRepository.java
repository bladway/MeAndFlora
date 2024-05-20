package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;

import java.util.Optional;

@Repository
public interface MafUserRepository extends JpaRepository<MafUser, Long> {
    Optional<MafUser> findByLogin(String login);
}
