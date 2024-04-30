package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "MAF_USER")
@NoArgsConstructor
@Data
public class MafUser {

    public MafUser(String login, String password, String role) {
        this.login = login;
        this.password = password;
        this.role = role;
    }

    @Id
    @Column(name = "LOGIN", nullable = false)
    private String login;

    @Column(name = "PASSWORD", nullable = false)
    private String password;

    @Column(name = "ROLE", nullable = false)
    private String role;

    @OneToMany(mappedBy = "user")
    private List<USession> sessionList;

}
