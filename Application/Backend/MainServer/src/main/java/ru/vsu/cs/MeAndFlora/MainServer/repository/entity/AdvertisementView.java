package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.util.List;

@Entity
@Table(name = "ADVERTISEMENT_VIEW")
@NoArgsConstructor
@Data
public class AdvertisementView {

    public AdvertisementView(USession session) {
        this.createdTime = OffsetDateTime.now();
        this.session = session;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "VIEW_ID", nullable = false)
    private Long viewId;

    @Column(name = "CREATED_TIME", nullable = false)
    private OffsetDateTime createdTime;

    @ManyToOne
    @JoinColumn(name = "SESSION_ID", foreignKey = @ForeignKey, nullable = false)
    private USession session;

}
