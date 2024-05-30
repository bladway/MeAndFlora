import 'package:freezed_annotation/freezed_annotation.dart';

part 'string_dto.g.dart';

@JsonSerializable()
class StringDto {
  const StringDto({ required this.string,});

  final String string;

  factory StringDto.fromJson(Map<String, dynamic> json) =>
      _$StringDtoFromJson(json);

  /// Connect the generated [_$StringDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StringDtoToJson(this);
}