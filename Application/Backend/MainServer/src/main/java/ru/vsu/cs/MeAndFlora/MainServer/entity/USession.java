package ru.vsu.cs.MeAndFlora.MainServer.entity;

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

@Entity
@Table(name = "U_SESSION")
@NoArgsConstructor
@Data
public class USession {

    public USession(MafUser user, String ipAddress, boolean isClosed) {
        this.user = user;
        this.ipAddress = ipAddress;
        this.isClosed = isClosed;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "SESSION_ID", nullable = false)
    private Long sessionId;

    @ManyToOne
    @JoinColumn(name = "LOGIN", foreignKey = @ForeignKey)
    private MafUser user;

    @Column(name = "IP_ADDRESS", nullable = false)
    private String ipAddress;

    @Column(name = "IS_CLOSED", nullable = false)
    private boolean isClosed;
}
