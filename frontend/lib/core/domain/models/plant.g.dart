// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plant _$PlantFromJson(Map<String, dynamic> json) => Plant(
      name: json['name'] as String? ?? "Неизвестно",
      type: json['type'] == null
          ? PlantType.unknown
          : Plant._plantTypeFromJson(json['type'] as String),
      description: json['description'] as String? ?? "Описание отсутствует",
      lon: (json['lon'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      subscribed: json['subscribed'] as bool? ?? false,
      path: json['path'] as String? ?? "",
    );

Map<String, dynamic> _$PlantToJson(Plant instance) => <String, dynamic>{
      'name': instance.name,
      'type': Plant._plantTypeToJson(instance.type),
      'description': instance.description,
      'lon': instance.lon,
      'lat': instance.lat,
      'date': instance.date?.toIso8601String(),
      'subscribed': instance.subscribed,
      'path': instance.path,
    };
