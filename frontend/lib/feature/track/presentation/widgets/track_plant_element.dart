import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/presentation/widgets/plant_image.dart';
import 'package:me_and_flora/core/presentation/widgets/plant_tile.dart';

import '../../../../core/app_router/app_router.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/theme/theme.dart';

class TrackPlantElement extends StatelessWidget {
  const TrackPlantElement({super.key, required this.plant, required this.iconSize});

  final Plant plant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height * 0.4,
      decoration: BoxDecoration(
          color: colors.gray,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(PlantDetailsRoute(plant: plant));
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 5,
                child: PlantImage(plant: plant, iconSize: iconSize,),
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
                              ? "lon: ${plant.lon} lat: ${plant.lat}"
                              : "Местоположение неизвестно",
                          icon: Iconsax.location,
                        ),
                      ),
                      Expanded(
                        child: PlantTile(
                          titleText: plant.date != null
                              ? plant.date!.day.toString()
                              : "Дата неизвестна",
                          icon: Icons.timer_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
