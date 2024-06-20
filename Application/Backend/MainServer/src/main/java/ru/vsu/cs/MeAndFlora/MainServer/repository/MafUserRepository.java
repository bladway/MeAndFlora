package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.MafUser;

import java.util.List;
import java.util.Optional;

@Repository
public interface MafUserRepository extends JpaRepository<MafUser, Long> {
    Optional<MafUser> findByLogin(String login);

    Page<MafUser> findByRoleIn(List<String> roleList, Pageable pageable);
}
