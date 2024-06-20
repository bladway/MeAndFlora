import 'package:me_and_flora/core/domain/service/auth_service.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_history_client.dart';

import '../models/models.dart';

class HistoryService {
  final historyClient = RestHistoryClient(AuthService.api);

  Future<Map<int, Plant>> getHistoryPlants(int page, int size) async {
    final publicationIds = await historyClient.getHistory(page, size);
    Map<int, Plant> plantList = {};
    for (var id in publicationIds.longs) {
      plantList[id] = await locator<PlantService>().getPlantByRequestId(id);
    }
    return plantList;
  }

  Stream<Map<int, Plant>> getStreamHistoryPlants(
      int page, int size, Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getHistoryPlants(page, size);
    }
  }
}
