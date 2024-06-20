// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDto _$RequestDtoFromJson(Map<String, dynamic> json) => RequestDto(
      floraName: json['floraName'] as String?,
      geoDto: json['geoDto'] == null
          ? null
          : GeoDto.fromJson(json['geoDto'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdTime: json['createdTime'] as String,
      postedTime: json['postedTime'] as String?,
      path: json['path'] as String,
      botanistVerified: json['botanistVerified'] as bool,
    );

Map<String, dynamic> _$RequestDtoToJson(RequestDto instance) =>
    <String, dynamic>{
      'floraName': instance.floraName,
      'geoDto': instance.geoDto,
      'status': instance.status,
      'createdTime': instance.createdTime,
      'postedTime': instance.postedTime,
      'path': instance.path,
      'botanistVerified': instance.botanistVerified,
    };
