package ru.vsu.cs.MeAndFlora.MainServer.repository.entity;

import java.util.List;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;

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

    /*@Column(name = "IS_ADMIN", nullable = false)
    private boolean isAdmin;

    @Column(name = "IS_BOTANIST", nullable = false)
    private boolean isBotanist;*/

    @OneToMany(mappedBy = "user")
    private List<USession> sessionList;

}
