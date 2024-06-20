// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_dto_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatDtoList _$StatDtoListFromJson(Map<String, dynamic> json) => StatDtoList(
      statDtoList: (json['statDtoList'] as List<dynamic>)
          .map((e) => StatDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatDtoListToJson(StatDtoList instance) =>
    <String, dynamic>{
      'statDtoList': instance.statDtoList,
    };
