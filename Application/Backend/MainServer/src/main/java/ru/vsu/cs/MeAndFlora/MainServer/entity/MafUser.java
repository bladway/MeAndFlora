package ru.vsu.cs.MeAndFlora.MainServer.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "MAF_USER")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class MafUser {
    @Id
    @Column(name = "LOGIN", nullable = false)
    String login;

    @Column(name = "PASSWORD", nullable = false)
    String password;

    @Column(name = "IS_ADMIN", nullable = false)
    boolean isAdmin;

    @Column(name = "IS_BOTANIST", nullable = false)
    boolean isBotanist;
}
