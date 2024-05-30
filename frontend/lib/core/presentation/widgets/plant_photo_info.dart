import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../domain/models/models.dart';
import 'widgets.dart';

class PlantPhotoInfo extends StatelessWidget {
  const PlantPhotoInfo({super.key, required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.3 * 0.1),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              plant.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: PlantTile(
              titleText: plant.lon != null && plant.lat != null
                  ? "${plant.lat}°, ${plant.lon}°"
                  : "Местоположение неизвестно",
              icon: Iconsax.location,
            ),
          ),
          Expanded(
            child: PlantTile(
              titleText: plant.date != null
                  ? plant.date!.toString().substring(0, 10)
                  : "Дата неизвестна",
              icon: Icons.timer_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
