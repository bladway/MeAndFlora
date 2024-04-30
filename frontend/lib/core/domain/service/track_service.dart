import 'dart:math';

import 'package:dio/dio.dart';

import '../models/models.dart';
import '../models/plant_type.dart';

List<Plant> plantList = [];

class TrackService {
  Future<void> trackPlant(String accountId, Plant plant) async {
    final response = await Dio().put("path", data: plant);
  }

  Future<List<Plant>> getTrackPlants(String accountId) async {
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
    return dataList;
    */
    for (int i = 0; i < 30; i++) {
      plantList.add(Plant(
          name: "Plant${i + 1}",
          type: PlantType.values.elementAt(Random().nextInt(4)),
          description:
          "Цвето́к (множ. цветки́, лат. flos, -oris, др.-греч. ἄνθος, -ου) — "
              "система органов семенного размножения цветковых (покрытосеменных)"
              " растений.",
          isTracked: i % 2 == 0,
          imageUrl: "something",
          lat: Random().nextInt(50).toDouble(),
          lon: Random().nextInt(50).toDouble()),
      );
    }
    return plantList;
  }
}