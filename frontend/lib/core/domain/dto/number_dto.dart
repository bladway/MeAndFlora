import 'package:freezed_annotation/freezed_annotation.dart';

part 'number_dto.g.dart';

@JsonSerializable()
class NumberDto {
  const NumberDto({ required this.number,});

  final int number;

  factory NumberDto.fromJson(Map<String, dynamic> json) =>
      _$NumberDtoFromJson(json);

  /// Connect the generated [_$NumberDtoDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NumberDtoToJson(this);
}