// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatDto _$StatDtoFromJson(Map<String, dynamic> json) => StatDto(
      date: DateTime.parse(json['date'] as String),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$StatDtoToJson(StatDto instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'count': instance.count,
    };
