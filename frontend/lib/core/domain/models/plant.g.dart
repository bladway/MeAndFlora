// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plant _$PlantFromJson(Map<String, dynamic> json) => Plant(
      name: json['name'] as String? ?? "Неизвестно",
      type: $enumDecodeNullable(_$PlantTypeEnumMap, json['type']) ??
          PlantType.unknown,
      description: json['description'] as String? ?? "Описание отсутствует",
      lon: (json['lon'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      isTracked: json['isTracked'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$PlantToJson(Plant instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$PlantTypeEnumMap[instance.type]!,
      'description': instance.description,
      'lon': instance.lon,
      'lat': instance.lat,
      'date': instance.date?.toIso8601String(),
      'isTracked': instance.isTracked,
      'imageUrl': instance.imageUrl,
    };

const _$PlantTypeEnumMap = {
  PlantType.flower: 'flower',
  PlantType.tree: 'tree',
  PlantType.grass: 'grass',
  PlantType.moss: 'moss',
  PlantType.unknown: 'unknown',
};
