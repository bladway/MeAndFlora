import 'dart:math';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/dto/string_dto.dart';
import 'package:me_and_flora/core/domain/dto/user_info_dto_list.dart';
import 'package:me_and_flora/core/domain/service/auth_service.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_user_client.dart';

import '../models/models.dart';

class AccountService {
  static final Dio dio = AuthService.api;
  final client = RestUserClient(dio);

  Future<void> addAccount(Account account) async {
    await client.createAccountByAdmin(account: account);
  }

  Future<void> seeAdvertisement() async {
    await client.seeAdvertisement();
  }

  Future<List<Account>> getAccountList(int page, int? size) async {
    final UserInfoDtoList userInfoDtoList = await client.getAccounts(page, size);
    return userInfoDtoList.userInfoDtoList;
  }

  Future<void> removeAccount(String login) async {
    await client.deleteUser(string: StringDto(string: login));
  }
}
