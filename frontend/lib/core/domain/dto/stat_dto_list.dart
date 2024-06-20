import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:me_and_flora/core/domain/dto/stat_dto.dart';

part 'stat_dto_list.g.dart';

@JsonSerializable()
class StatDtoList {
  const StatDtoList({required this.statDtoList});

  final List<StatDto> statDtoList;

  factory StatDtoList.fromJson(Map<String, dynamic> json) =>
      _$StatDtoListFromJson(json);
}