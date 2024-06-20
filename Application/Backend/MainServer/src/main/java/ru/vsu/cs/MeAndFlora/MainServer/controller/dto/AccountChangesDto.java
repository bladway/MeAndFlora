package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AccountChangesDto {

    public AccountChangesDto(String newLogin, String newPassword, String oldPassword) {
        this.newLogin = newLogin;
        this.newPassword = newPassword;
        this.oldPassword = oldPassword;
    }

    private String newLogin;
    private String newPassword;
    private String oldPassword;

}