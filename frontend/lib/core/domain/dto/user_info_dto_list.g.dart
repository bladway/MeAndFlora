// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_dto_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoDtoList _$UserInfoDtoListFromJson(Map<String, dynamic> json) =>
    UserInfoDtoList(
      userInfoDtoList: (json['userInfoDtoList'] as List<dynamic>)
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserInfoDtoListToJson(UserInfoDtoList instance) =>
    <String, dynamic>{
      'userInfoDtoList': instance.userInfoDtoList,
    };
