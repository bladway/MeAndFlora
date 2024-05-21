package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.AdvertisementView;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;

import java.util.List;
import java.util.Optional;

@Repository
public interface AdvertisementViewRepository extends JpaRepository<AdvertisementView, Long> {

}