import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/presentation/widgets/plant_image.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../domain/models/models.dart';
import '../bloc/plant_track/plant_track.dart';
import 'buttons/track_button.dart';

class PlantElement extends StatefulWidget {
  const PlantElement({super.key, required this.plant});

  final Plant plant;

  @override
  State<PlantElement> createState() => _PlantElementState();
}

class _PlantElementState extends State<PlantElement> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      width: width * 0.42,
      decoration: BoxDecoration(
          color: colors.gray,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(PlantDetailsRoute(plant: widget.plant));
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  height: height * 0.1,
                  width: width * 0.39,
                  padding: const EdgeInsets.only(top: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PlantImage(image: widget.plant.path, size: 35),
                        Align(
                          alignment: Alignment.topRight,
                          child: BlocBuilder<PlantTrackBloc, PlantTrackState>(
                              builder: (context, state) {
                            return TrackButton(
                              plant: widget.plant,
                              size: height * width * 0.000074,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Text(
                          widget.plant.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 8,
                        child: Text(
                          widget.plant.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400, //Regular
                            color: colors.white,
                          ),
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
