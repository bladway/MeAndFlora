package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import java.time.OffsetDateTime;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.service.impl.FloraServiceImpl;

@Entity
@Table(name = "PROC_REQUEST")
@NoArgsConstructor
@Data
public class ProcRequest {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "REQUEST_ID", nullable = false)
    private Long requestId;

    @Column(name = "IMAGE_PATH", nullable = false)
    private String imagePath;

    @Column(name = "CREATED_TIME", nullable = false)
    private OffsetDateTime createdTime;

    @Column(name = "POSTED_TIME", nullable = false)
    private OffsetDateTime postedTime;

    @Column(name = "GEO_RAW")
    private Point geoRaw;

    @Column(name = "GEO_POS", columnDefinition = "geometry(Point,4326)")
    private Point geoPos = FloraServiceImpl.geometryFactory.createPoint(new Coordinate(geoRaw.getX(), geoRaw.getY()));

    @Column(name = "IS_BOTANIST_PROC", nullable = false)
    private boolean isBotanistProc;

    @Column(name = "IS_NEURAL_PROC", nullable = false)
    private boolean isNeuralProc;

    @Column(name = "IS_PUBLISHED", nullable = false)
    private boolean isPublished;

    @Column(name = "IS_BAD", nullable = false)
    private boolean isBad;

    @ManyToOne
    @JoinColumn(name = "SESSION_ID", foreignKey = @ForeignKey)
    private USession session;

    @ManyToOne
    @JoinColumn(name = "FLORA_ID", foreignKey = @ForeignKey)
    private Flora flora;
    
}
