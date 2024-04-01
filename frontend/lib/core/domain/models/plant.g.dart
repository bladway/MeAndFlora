// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantImpl _$$PlantImplFromJson(Map<String, dynamic> json) => _$PlantImpl(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      isLiked: json['isLiked'] as bool,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$PlantImplToJson(_$PlantImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'isLiked': instance.isLiked,
      'imageUrl': instance.imageUrl,
    };
