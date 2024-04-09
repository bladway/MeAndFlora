import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'access_level.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const Account._();
  const factory Account({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String phone,
    required AccessLevel accessLevel,
  }) = _Account;

  factory Account.fromJson(Map<String, Object?> json)
  => _$AccountFromJson(json);
}
