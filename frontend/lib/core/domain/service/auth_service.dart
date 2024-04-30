import 'package:me_and_flora/core/exception/auth_exception.dart';

import '../models/models.dart';

class AuthService {
  Future<Account> getAccount(String login) async {
    return Account(
        login: login, password: "password", accessLevel: AccessLevel.user);
  }

  Future<Account> signUp(String login, String pass) async {
    //final response = await Dio().post('$url/auth/register');
    return Account(login: login, password: pass, accessLevel: AccessLevel.user);
  }

  Future<Account> signIn(String login, String pass) async {
    if (login == "admin_" && pass == "admin_") {
      return Account(
          login: "admin_", password: "admin_", accessLevel: AccessLevel.admin);
    } else if (login == "botanic" && pass == "botanic") {
      return Account(login: "botanic", password: "botanic", accessLevel: AccessLevel.botanic);
    } else if (login == "user__" && pass == "user__") {
      return Account(login: "user__", password: "user__", accessLevel: AccessLevel.user);
    } else {
      throw UserNotFoundException();
    }
    //final response = await Dio().post('$url/auth/login', data: {login: login, password: pass, ipAddress: ''});
    //final data = response.data as Map<String, dynamic>;
    //return Account(login: data['login'], password: data['password'], accessLevel: data['accessLevel']);
  }

  bool isLoggedIn() {
    return true;
  }
}
