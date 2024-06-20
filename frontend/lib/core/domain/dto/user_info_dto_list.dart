import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:me_and_flora/core/domain/models/models.dart';

part 'user_info_dto_list.g.dart';

@JsonSerializable()
class UserInfoDtoList {
  const UserInfoDtoList({required this.userInfoDtoList});

  final List<Account> userInfoDtoList;

  factory UserInfoDtoList.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoListFromJson(json);
}