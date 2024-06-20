// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ident_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentResponseDto _$IdentResponseDtoFromJson(Map<String, dynamic> json) =>
    IdentResponseDto(
      requestId: (json['requestId'] as num).toInt(),
      floraDto: Plant.fromJson(json['floraDto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IdentResponseDtoToJson(IdentResponseDto instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'floraDto': instance.floraDto,
    };
