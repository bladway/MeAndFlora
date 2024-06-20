import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/stat_dto_list.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_statistic_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestStatisticClient {
  factory RestStatisticClient(Dio dio, {String baseUrl}) = _RestStatisticClient;

  @GET('/stats/requests')
  Future<StatDtoList> getRequestsStatistic(
      @Query('startTime') String startTime,
      @Query('endTime') String endTime,
      @Query('page') int? page,
      @Query('size') int? size
      );

  @GET('/stats/adverts')
  Future<StatDtoList> getAdvertisementStatistic(
      @Query('startTime') String startTime,
      @Query('endTime') String endTime,
      @Query('page') int? page,
      @Query('size') int? size
      );
}
