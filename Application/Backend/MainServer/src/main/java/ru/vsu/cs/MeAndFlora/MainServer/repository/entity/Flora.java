package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "FLORA")
@NoArgsConstructor
@Data
public class Flora {

    public Flora(String imagePath, String name, String description, String type) {
        this.imagePath = imagePath;
        this.name = name;
        this.description = description;
        this.type = type;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FLORA_ID", nullable = false)
    private Long floraId;

    @Column(name = "IMAGE_PATH", nullable = false, unique = true)
    private String imagePath;

    @Column(name = "NAME", nullable = false, unique = true)
    private String name;

    @Column(name = "DESCRIPTION", nullable = false)
    private String description;

    @Column(name = "TYPE", nullable = false)
    private String type;

    @OneToMany(mappedBy = "flora")
    private List<ProcRequest> procRequestList;

}
