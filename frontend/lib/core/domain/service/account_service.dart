import 'dart:math';

import 'package:me_and_flora/core/exception/account_exception.dart';
import 'package:me_and_flora/core/domain/service/auth_service.dart';

import '../models/models.dart';

List<Account> accountList = [];

class AccountService {
  Future<void> addAccount(Account account) async {
    //final response = await Dio().post("path");
    accountList.add(account);
  }

  Future<Account> editAccount(String prevLogin, String? login, String? password,
      String? passwordConfirm) async {
    if (login == "" && password == "") {
      throw AccountEditException();
    }
    Account account = await AuthService().getAccount(prevLogin);
    //final response = await Dio().update("", data: {});
    if (passwordConfirm != account.password) {
      throw AccountEditException();
    }
    Account account2 = account.copyWith(
        login: login != "" ? login : account.login,
        password: password != '' ? password : account.password);
    return account2;
  }

  Future<List<Account>> getAccountList() async {
    /*
    final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
            name: e.value['name'],
            type: e.value['type'],
            description: e.value['description'],
            isLiked: e.value['isLiked'],
            imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    for (int i = 0; i < 100; i++) {
      accountList.add(Account(
          login: "Пользователь${i + 1}",
          password: "password${i + 1}",
          accessLevel: AccessLevel.values.elementAt(Random().nextInt(2) + 1)));
    }
    return accountList;
  }

  Future<void> removeAccount(Account account) async {
    accountList.remove(account);
  }
}
