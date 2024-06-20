import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/plant_names.dart';
import 'package:me_and_flora/core/domain/dto/string_dto.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_flora_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestFloraClient {
  factory RestFloraClient(Dio dio, {String baseUrl}) = _RestFloraClient;

  @GET('/flora/byName')
  Future<Plant> findPlantByName(@Query('floraName') String plantName);

  @GET('/flora/allByType')
  Future<PlantNames> getNamesByType(
    @Query('typeName') String typeName,
    @Query('page') int page,
    @Query('size') int size,
  );

  @POST('/flora/create')
  @MultiPart()
  Future<dynamic> postPlant({
    @Part() required Plant floraDto,
    @Part() required File image,
  });

  @PUT('/flora/subscribe')
  Future<StringDto> subscribe({@Query('floraName') required String floraName});
}

// List<String> deserializeNamesList(List<Map<String, dynamic>> json) =>
//     json.map((e) => e.toString()).toList();
PlantNames deserializePlantNames(Map<String, dynamic> json) =>
    PlantNames.fromJson(json);
