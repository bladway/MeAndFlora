// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongListDto _$LongListDtoFromJson(Map<String, dynamic> json) => LongListDto(
      longs: (json['longs'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$LongListDtoToJson(LongListDto instance) =>
    <String, dynamic>{
      'longs': instance.longs,
    };
