package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.util.List;

@Entity
@Table(name = "U_SESSION")
@NoArgsConstructor
@Data
public class USession {

    public USession(String ipAddress, String jwt, String jwtR, MafUser user) {
        this.ipAddress = ipAddress;
        this.createdTime = OffsetDateTime.now();
        this.jwt = jwt;
        this.jwtR = jwtR;
        this.user = user;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SESSION_ID", nullable = false)
    private Long sessionId;

    @Column(name = "IP_ADDRESS", nullable = false)
    private String ipAddress;

    @Column(name = "CREATED_TIME", nullable = false)
    private OffsetDateTime createdTime;

    @Column(name = "JWT", nullable = false, unique = true)
    private String jwt;

    @Column(name = "JWT_R", nullable = false, unique = true)
    private String jwtR;

    @ManyToOne
    @JoinColumn(name = "LOGIN", foreignKey = @ForeignKey)
    private MafUser user;

    @OneToMany(mappedBy = "session")
    private List<ProcRequest> procRequestList;

}
