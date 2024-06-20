import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/domain/models/models.dart';
import '../../../../core/presentation/widgets/track_plant_image.dart';
import '../../../../core/presentation/widgets/plant_tile.dart';

class TrackPlantInfo extends StatelessWidget {
  const TrackPlantInfo({super.key, required this.plant, required this.iconSize});
  final Plant plant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
            child: TrackPlantImage(plant: plant, iconSize: iconSize,),
          ),
          Flexible(
            flex: 3,
            child: Container(
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
                          ? "${plant.lat!.toStringAsPrecision(4)}°, "
                          "${plant.lon!.toStringAsPrecision(4)}°"
                          : "Неизвестно",
                      icon: Iconsax.location,
                    ),
                  ),
                  Expanded(
                    child: PlantTile(
                      titleText: plant.date != null
                          ? plant.date!
                          .toString().substring(0, 10)
                          : "Дата неизвестна",
                      icon: Icons.timer_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
