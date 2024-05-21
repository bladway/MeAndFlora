package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

import java.time.OffsetDateTime;

@Entity
@Table(name = "PROC_REQUEST")
@NoArgsConstructor
@Data
public class ProcRequest {

    public ProcRequest(
            OffsetDateTime postedTime, String imagePath,
            Point geoPos, String status,
            USession session, Flora flora,
            boolean isBotanistVerified
    ) {
        this.createdTime = OffsetDateTime.now();
        this.postedTime = postedTime;
        this.imagePath = imagePath;
        this.geoPos = geoPos;
        this.status = status;
        this.session = session;
        this.flora = flora;
        this.isBotanistVerified = isBotanistVerified;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "REQUEST_ID", nullable = false)
    private Long requestId;

    @Column(name = "IMAGE_PATH", nullable = false)
    private String imagePath;

    @Column(name = "CREATED_TIME", nullable = false)
    private OffsetDateTime createdTime;

    @Column(name = "POSTED_TIME")
    private OffsetDateTime postedTime;

    @Column(name = "GEO_POS")
    private Point geoPos;

    @Column(name = "STATUS", nullable = false)
    private String status;

    @Column(name = "IS_BOTANIST_VERIFIED", nullable = false)
    private boolean isBotanistVerified;

    @ManyToOne
    @JoinColumn(name = "SESSION_ID", foreignKey = @ForeignKey)
    private USession session;

    @ManyToOne
    @JoinColumn(name = "FLORA_ID", foreignKey = @ForeignKey)
    private Flora flora;

}
