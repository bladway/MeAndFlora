// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantImpl _$$PlantImplFromJson(Map<String, dynamic> json) => _$PlantImpl(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      lon: json['lon'] as String?,
      lat: json['lat'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      isTracked: json['isTracked'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$PlantImplToJson(_$PlantImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'lon': instance.lon,
      'lat': instance.lat,
      'date': instance.date?.toIso8601String(),
      'isTracked': instance.isTracked,
      'imageUrl': instance.imageUrl,
    };
