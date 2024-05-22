package ru.vsu.cs.MeAndFlora.MainServer.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import ru.vsu.cs.MeAndFlora.MainServer.repository.entity.Flora;

import java.util.Optional;

@Repository
public interface FloraRepository extends JpaRepository<Flora, Long> {

    Optional<Flora> findByName(String name);

    @Query(value =
        "SELECT new java.lang.String(f.type) FROM Flora f GROUP BY f.type"
    )
    Page<String> getTypesOfFlora(Pageable pageable);

    Page<Flora> findByType(String type, Pageable pageable);

}
