package ru.vsu.cs.MeAndFlora.MainServer.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "U_SESSION")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class USession {
    @Id
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
