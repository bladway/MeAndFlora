import '../models/models.dart';

List<Plant> historyList = [];

class HistoryService {
  Future<void> addPlantToHistory(String accountId, Plant plant) async {
    //final response = await Dio().post("path", data: plant);
    historyList.insert(0, plant);
  }

  Future<List<Plant>> getHistoryPlants(String accountId, int pageNumber) async {
    /*
    final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
            name: e.value['name'],
            type: e.value['type'],
            description: e.value['description'],
            isLiked: e.value['isLiked'],
            imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    return historyList;
  }
}
