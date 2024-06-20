// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoDto _$GeoDtoFromJson(Map<String, dynamic> json) => GeoDto(
      type: json['type'] as String? ?? "Point",
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$GeoDtoToJson(GeoDto instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
