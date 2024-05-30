import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/bloc/plant/plant.dart';

import '../../../../core/app_router/app_router.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/theme.dart';

class PlantPublicElement extends StatelessWidget {
  const PlantPublicElement(
      {super.key, required this.plant, required this.iconSize});

  final Plant plant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      lazy: false,
      create: (context) => PlantBloc(),
      child: Container(
        height: height * 0.5,
        decoration: BoxDecoration(
            color: colors.gray,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: InkWell(
          onTap: () {
            AutoRouter.of(context).push(PlantDetailsRoute(plant: plant));
          },
          child: Column(children: [
            Flexible(
              flex: 7,
              child: TrackPlantImage(
                plant: plant,
                iconSize: iconSize,
              ),
            ),
            Flexible(
              flex: 3,
              child: PlantPhotoInfo(
                plant: plant,
              ),
            ),
            Flexible(
              flex: 3,
              child: BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.02),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [colors.lightGreen, colors.blueGreen])),
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<PlantBloc>(context)
                              .add(PlantRemoveRequested(publicId: 0));
                        },
                        child: Text(
                          'Удалить',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
