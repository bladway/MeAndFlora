import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:me_and_flora/core/domain/models/models.dart';

part 'ident_response_dto.g.dart';

@JsonSerializable()
class IdentResponseDto {
  const IdentResponseDto(
      {required this.requestId,
        required this.floraDto});

  final int requestId;
  final Plant floraDto;

  factory IdentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$IdentResponseDtoFromJson(json);
}