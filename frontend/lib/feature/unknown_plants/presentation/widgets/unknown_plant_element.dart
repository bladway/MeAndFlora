import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_router/app_router.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/theme/theme.dart';
import '../../../track/presentation/widgets/track_plant_info.dart';

class UnknownPlantElement extends StatelessWidget {
  const UnknownPlantElement(
      {super.key,
      required this.requestId,
      required this.plant,
      required this.iconSize});

  final int requestId;
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
          context.pushRoute(PlantIdentFormRoute(requestId: requestId, plant: plant));
        },
        child: TrackPlantInfo(
          plant: plant,
          iconSize: iconSize,
        ),
      ),
    );
  }
}
