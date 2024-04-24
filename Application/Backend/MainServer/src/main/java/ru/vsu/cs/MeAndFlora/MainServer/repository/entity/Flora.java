package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import java.util.List;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;

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
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "FLORA_ID", nullable = false)
    private Long floraId;

    @Column(name = "IMAGE_PATH", nullable = false)
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
