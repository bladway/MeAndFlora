import 'package:freezed_annotation/freezed_annotation.dart';

part 'stat_dto.g.dart';

@JsonSerializable()
class StatDto {
  const StatDto({ required this.date, required this.count,});

  final DateTime date;
  final int count;

  factory StatDto.fromJson(Map<String, dynamic> json) =>
      _$StatDtoFromJson(json);
}