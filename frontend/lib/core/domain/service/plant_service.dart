import 'dart:io';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/dto/answer_dto.dart';
import 'package:me_and_flora/core/domain/dto/geo_dto.dart';
import 'package:me_and_flora/core/domain/dto/ident_response_dto.dart';
import 'package:me_and_flora/core/domain/dto/long_list_dto.dart';
import 'package:me_and_flora/core/domain/dto/number_dto.dart';
import 'package:me_and_flora/core/domain/dto/plant_names.dart';
import 'package:me_and_flora/core/domain/service/auth_service.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_flora_client.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_publication_client.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_request_client.dart';
import 'package:me_and_flora/core/exception/ident_limit_exception.dart';
import 'package:me_and_flora/core/exception/plant_exception.dart';

import '../models/models.dart';

class PlantService {
  //static final Dio dio = locator.get(instanceName: "dio");
  static final Dio dio = AuthService.api;
  final client = RestFloraClient(dio);
  final requestClient = RestRequestClient(dio);
  final publicClient = RestPublicationClient(dio);

  Future<List<Plant>> getByType(String type, int page, int size) async {
    PlantNames plantNames = await client.getNamesByType(type, page, size);
    List<dynamic> names = plantNames.strings;

    List<Plant> plants = [];

    for (var name in names) {
      plants.add(await client.findPlantByName(name));
    }

    return plants;
  }

  Future<List<Plant>> getFlowers(int page, int size) async {
    return await getByType('Цветок', page, size);
  }

  Future<List<Plant>> getTrees(int page, int size) async {
    return await getByType('Дерево', page, size);
  }

  Future<List<Plant>> getGrass(int page, int size) async {
    return await getByType('Трава', page, size);
  }

  Future<List<Plant>> getMoss(int page, int size) async {
    return await getByType('Мох', page, size);
  }

  Future<Plant> findPlantByName(String plantName) async {
    if (plantName == "Error") {
      throw PlantNotFoundException();
    }

    final String name =
        "${plantName[0].toUpperCase()}${plantName.substring(1).toLowerCase()}";
    return await client.findPlantByName(name);
  }

  Future<IdentResponseDto> findPlantByPhoto(
      GeoDto? point, String imagePath) async {
    try {
      final File image = File(imagePath);
      final response =
          await requestClient.requestIdent(geoDto: point, image: image);
      return response;
    } on Exception catch (_) {
      try {
        final File image = File(imagePath);
        final response =
            await requestClient.requestIdent(geoDto: point, image: image);
        return response;
      } on Exception catch (_) {
        throw IdentLimitException();
      }
    }
  }

  Future<Map<int, Plant>> getUnknownPlantsByBotanic(int page, int size) async {
    final LongListDto requestIdList =
        await requestClient.getRequestIdList(page, size);

    Map<int, Plant> plantList = {};
    for (var requestId in requestIdList.longs) {
      plantList[requestId] = await getPlantByRequestId(requestId);
    }
    return plantList;
  }

  Future<void> sendUserDecision(int requestId, String isCorrect) async {
    await requestClient.postUserDecision(
        answerDto: AnswerDto(requestId: requestId, answer: isCorrect));
  }

  Future<void> sendUserCorrectDecision(int requestId) async {
    await requestClient.postUserDecision(
        answerDto: AnswerDto(requestId: requestId, answer: "yes"));
  }

  Future<void> sendUserIncorrectDecision(int requestId) async {
    await requestClient.postUserDecision(
        answerDto: AnswerDto(requestId: requestId, answer: "no"));
  }

  Future<void> sendBotanicDecision(int requestId, String name) async {
    await requestClient.requestBotanicDecision(
        answerDto: AnswerDto(requestId: requestId, answer: name));
  }

  Future<void> sendImpossibleIdentDecision(int requestId) async {
    await sendBotanicDecision(requestId, "bad");
  }

  Future<void> sendSuccessIdentDecision(int requestId, Plant plant) async {
    await sendBotanicDecision(requestId, plant.name);

    final File image = File(plant.path);
    await client.postPlant(floraDto: plant, image: image);
  }

  Future<void> removePublication(int publicId) async {
    await publicClient.deletePublication(number: NumberDto(number: publicId));
  }

  Future<Plant> getPlantByRequestIdByAdmin(int requestId) async {
    final requestDto = await requestClient.getRequest(requestId);
    return Plant(
        name: requestDto.floraName ?? "Неизвестно",
        lon: requestDto.geoDto?.coordinates.first,
        lat: requestDto.geoDto?.coordinates.last,
        date: requestDto.postedTime != null
            ? DateTime.parse(requestDto.postedTime!)
            : null,
        path: requestDto.path);
  }

  Future<String> getImageByRequestId(int requestId) async {
    final requestDto = await requestClient.getRequest(requestId);
    return requestDto.path;
  }

  Future<Plant> getPlantByRequestId(int requestId) async {
    final requestDto = await requestClient.getRequest(requestId);
    late Plant plant;
    if (requestDto.floraName != null && requestDto.floraName != "") {
      plant = await client.findPlantByName(requestDto.floraName!);
    } else {
      plant = Plant();
    }
    Plant newPlant = plant.copyWith(
        date: DateTime.parse(requestDto.createdTime),
        lon: requestDto.geoDto?.coordinates.last,
        lat: requestDto.geoDto?.coordinates.first,
        image: requestDto.path);
    return newPlant;
  }
}
