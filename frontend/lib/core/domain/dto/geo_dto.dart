import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_dto.g.dart';

@JsonSerializable()
class GeoDto {
  const GeoDto({this.type = "Point", required this.coordinates});

  final String type;
  final List<double> coordinates;

  factory GeoDto.fromJson(Map<String, dynamic> json) =>
      _$GeoDtoFromJson(json);

  /// Connect the generated [_$GeoDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GeoDtoToJson(this);
}