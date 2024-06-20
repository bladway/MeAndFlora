// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerDto _$AnswerDtoFromJson(Map<String, dynamic> json) => AnswerDto(
      requestId: (json['requestId'] as num).toInt(),
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$AnswerDtoToJson(AnswerDto instance) => <String, dynamic>{
      'requestId': instance.requestId,
      'answer': instance.answer,
    };
