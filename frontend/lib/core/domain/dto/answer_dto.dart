import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_dto.g.dart';

@JsonSerializable()
class AnswerDto {
  const AnswerDto({required this.requestId, required this.answer,});

  final int requestId;
  final String answer;

  factory AnswerDto.fromJson(Map<String, dynamic> json) =>
      _$AnswerDtoFromJson(json);

  /// Connect the generated [_$AnswerDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AnswerDtoToJson(this);
}