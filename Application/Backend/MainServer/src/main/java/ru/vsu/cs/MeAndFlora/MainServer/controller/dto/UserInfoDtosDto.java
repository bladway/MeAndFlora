package ru.vsu.cs.MeAndFlora.MainServer.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class UserInfoDtosDto {

    public UserInfoDtosDto(List<UserInfoDto> userInfoDtoList) {
        this.userInfoDtoList = userInfoDtoList;
    }

    private List<UserInfoDto> userInfoDtoList;

}