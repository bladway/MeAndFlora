// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      accessLevel: $enumDecode(_$AccessLevelEnumMap, json['accessLevel']),
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'accessLevel': _$AccessLevelEnumMap[instance.accessLevel]!,
    };

const _$AccessLevelEnumMap = {
  AccessLevel.unauth_user: 'unauth_user',
  AccessLevel.user: 'user',
  AccessLevel.botanic: 'botanic',
  AccessLevel.admin: 'admin',
};
