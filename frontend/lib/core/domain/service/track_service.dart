import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/service/auth_service.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_flora_client.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_publication_client.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_request_client.dart';

import '../models/models.dart';

class TrackService {
  static final Dio dio = AuthService.api;
  final publicationClient = RestPublicationClient(dio);
  final floraClient = RestFloraClient(dio);
  final requestClient = RestRequestClient(dio);

  Future<void> trackPlant(String plantName) async {
    await floraClient.subscribe(floraName: plantName);
  }

  Future<Map<int, Plant>> getTrackPlantsByAdmin(int page, int size) async {
    final publicationIds =
        await publicationClient.getPublicIdsByAdmin(page, size);

    Map<int, Plant> plantList = {};
    for (var id in publicationIds.longs) {
      plantList[id] = await locator<PlantService>().getPlantByRequestIdByAdmin(id);
    }

    return plantList;
  }

  Stream<Map<int, Plant>> getStreamTrackPlantsByAdmin(
      int page, int size, Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getTrackPlantsByAdmin(page, size);
    }
  }

  Future<Map<int, Plant>> getTrackPlantsByUser(int page, int size) async {
    final publicationIds =
        await publicationClient.getPublicIdsByUser(page, size);

    Map<int, Plant> plantList = {};
    for (var id in publicationIds.longs) {
      plantList[id] = await locator<PlantService>().getPlantByRequestId(id);
    }
    return plantList;
  }

  Stream<Map<int, Plant>> getStreamTrackPlantsByUser(
      int page, int size, Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getTrackPlantsByUser(page, size);
    }
  }
}
