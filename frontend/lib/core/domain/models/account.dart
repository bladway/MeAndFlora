import 'package:freezed_annotation/freezed_annotation.dart';

import 'access_level.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  String login;
  String password;
  AccessLevel accessLevel;

  Account({
    this.login = "Незарегистрированный пользователь",
    this.password = "Пароль",
    this.accessLevel = AccessLevel.unauth_user,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// Connect the generated [_$AccountToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account copyWith({
    String? login,
    String? password,
    AccessLevel? accessLevel
  }) {
    return Account(login: login ?? this.login,
        password: password ?? this.password,
        accessLevel: accessLevel ?? this.accessLevel);
  }
}

/*
part 'account.freezed.dart';

part 'account.g.dart';

@freezed
class Account with _$Account {
  const Account._();

  const factory Account({
    required String login,
    required String password,
    required AccessLevel accessLevel,
  }) = _Account;

  factory Account.fromJson(Map<String, Object?> json) =>
      _$AccountFromJson(json);
}
*/