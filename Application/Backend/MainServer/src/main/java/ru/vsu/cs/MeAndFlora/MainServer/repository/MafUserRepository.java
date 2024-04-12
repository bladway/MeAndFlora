package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ru.vsu.cs.MeAndFlora.MainServer.entity.MafUser;

@Repository
public interface MafUserRepository extends JpaRepository<MafUser, String> {
    
}
