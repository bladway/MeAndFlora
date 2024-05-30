import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:me_and_flora/core/domain/dto/geo_dto.dart';

part 'request_dto.g.dart';

@JsonSerializable()
class RequestDto {
  const RequestDto(
      {required this.floraName,
      required this.geoDto,
      required this.status,
      required this.createdTime,
      required this.postedTime,
      required this.path,
      required this.botanistVerified});

  final String? floraName;
  final GeoDto? geoDto;
  final String status;
  final String createdTime;
  final String? postedTime;
  final String path;
  final bool botanistVerified;

  factory RequestDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDtoFromJson(json);
}
