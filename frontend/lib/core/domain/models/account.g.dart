// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      login: json['login'] as String? ?? "Пользователь",
      password: json['password'] as String? ?? "Пароль",
      accessLevel:
          $enumDecodeNullable(_$AccessLevelEnumMap, json['accessLevel']) ??
              AccessLevel.unauth_user,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'accessLevel': _$AccessLevelEnumMap[instance.accessLevel]!,
    };

const _$AccessLevelEnumMap = {
  AccessLevel.unauth_user: 'unauth_user',
  AccessLevel.user: 'user',
  AccessLevel.botanic: 'botanic',
  AccessLevel.admin: 'admin',
};
