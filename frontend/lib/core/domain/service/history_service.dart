import 'package:me_and_flora/core/domain/service/auth_service.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_history_client.dart';

import '../models/models.dart';

class HistoryService {
  // Future<void> addPlantToHistory(String accountId, Plant plant) async {
  //   //final response = await Dio().post("path", data: plant);
  //   historyList.insert(0, plant);
  // }

  final historyClient = RestHistoryClient(AuthService.api);

  Future<List<Plant>> getHistoryPlants(int page, int size) async {
    final publicationIds = await historyClient.getHistory(page, size);
    List<Plant> plantList = [];
    for (var id in publicationIds.longs) {
      plantList.add(await locator<PlantService>().getPlantByRequestId(id));
    }
    return plantList;
  }
}
