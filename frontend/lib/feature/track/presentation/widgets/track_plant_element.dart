import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/feature/track/presentation/widgets/track_plant_info.dart';

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
        child: TrackPlantInfo(plant: plant, iconSize: iconSize,),
      ),
    );
  }
}
