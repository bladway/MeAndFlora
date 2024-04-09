import 'package:flutter/material.dart';

import '../../../../core/domain/models/models.dart';
import 'history_plant_element.dart';

class PlantGrid extends StatelessWidget {
  final List<Plant> _plantList;

  const PlantGrid({super.key, required List<Plant> plantList})
      : _plantList = plantList;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: _plantList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return HistoryPlantElement(plant: _plantList[index], iconSize: height * 0.3 * 0.15);
        },
      ),
    );
  }
}
