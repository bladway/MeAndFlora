// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      login: json['login'] as String? ?? "Незарегистрированный пользователь",
      password: json['password'] as String? ?? "Пароль",
      role: $enumDecodeNullable(_$AccessLevelEnumMap, json['role']) ??
          AccessLevel.unauth_user,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'role': _$AccessLevelEnumMap[instance.role]!,
    };

const _$AccessLevelEnumMap = {
  AccessLevel.unauth_user: 'unauth_user',
  AccessLevel.user: 'user',
  AccessLevel.botanist: 'botanist',
  AccessLevel.admin: 'admin',
};
