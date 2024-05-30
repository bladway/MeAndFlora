import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/answer_dto.dart';
import 'package:me_and_flora/core/domain/dto/geo_dto.dart';
import 'package:me_and_flora/core/domain/dto/ident_response_dto.dart';
import 'package:me_and_flora/core/domain/dto/long_list_dto.dart';
import 'package:me_and_flora/core/domain/dto/plant_names.dart';
import 'package:me_and_flora/core/domain/dto/request_dto.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_request_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestRequestClient {
  factory RestRequestClient(Dio dio, {String baseUrl}) = _RestRequestClient;

  @GET('/request/byId')
  Future<RequestDto> getRequest(@Query('requestId') int requestId);

  @GET('/request/allByBotanist')
  Future<LongListDto> getRequestIdList(
    @Query('page') int page,
    @Query('size') int size,
  );

  @POST('/request/create')
  @MultiPart()
  Future<IdentResponseDto> requestIdent({
    @Part() GeoDto? point,
    @Part() required File image,
  });

  @PUT('/request/botanistDecision')
  Future<void> requestBotanicDecision({@Body() required AnswerDto answerDto});

  @PUT('/request/userDecision')
  Future<void> postUserDecision({@Body() required AnswerDto answerDto});
}
