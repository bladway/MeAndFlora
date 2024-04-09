import 'package:dio/dio.dart';

import '../models/models.dart';

class HistoryService {
  Future<void> addPlantToHistory(String accountId, Plant plant) async {
    final response = await Dio().post("path", data: plant);
  }

  Future<List<Plant>> getPlantHistory(String accountId) async {
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
    return [
      const Plant(
          name: "Plant1",
          type: "Дерево",
          description:
          "fvjnsjnsdjfnsjkfnsjdbkjbilnbknlknjlkmlmjljmlknjknjkbjkbhnv kbjlkjbnlknklnjcnsdjcnscjsdc",
          isTracked: true,
          imageUrl: "something"),
      const Plant(
          name: "Plant2",
          type: "Дерево",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: false,
          imageUrl: "something"),
      const Plant(
          name: "Plant3",
          type: "Мох",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: false,
          imageUrl: "something"),
      const Plant(
          name: "Plant4",
          type: "Мох",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: false,
          imageUrl: "something"),
      const Plant(
          name: "Plant5",
          type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: true,
          imageUrl: "something"),
      const Plant(
          name: "Plant6",
          type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: false,
          imageUrl: "something"),
      const Plant(
          name: "Plant7",
          type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: true,
          imageUrl: "something"),
      const Plant(
          name: "Plant8",
          type: "Мох",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: true,
          imageUrl: "something"),
      const Plant(
          name: "Plant9",
          type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: false,
          imageUrl: "something"),
      const Plant(
          name: "Plant10",
          type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isTracked: true,
          imageUrl: "something"),
    ];
  }
}
