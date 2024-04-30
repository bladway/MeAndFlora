import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/app_router/app_router.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/presentation/widgets/track_plant_image.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/presentation/widgets/plant_tile.dart';

class HistoryPlantElement extends StatelessWidget {
  const HistoryPlantElement(
      {super.key, required this.plant, required this.iconSize});

  final Plant plant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height * 0.35,
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
                flex: 4,
                child: TrackPlantImage(
                  plant: plant,
                  iconSize: iconSize,
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(
                      right: width * 0.3 * 0.1,
                      left: width * 0.3 * 0.1,
                      bottom: height * 0.35 * 0.05),
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
                              ? "${plant.lon!.toStringAsPrecision(4)}°, "
                                  "${plant.lat!.toStringAsPrecision(4)}°"
                              : "Неизвестно",
                          icon: Iconsax.location_copy,
                        ),
                      ),
                      Expanded(
                        child: PlantTile(
                          titleText: plant.date != null
                              ? plant.date!
                                  .toString()
                                  .replaceAll('00:00:00.000', '')
                              : "Неизвестно",
                          icon: Icons.timer_outlined,
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
