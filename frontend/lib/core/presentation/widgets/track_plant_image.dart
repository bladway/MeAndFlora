import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_track/plant_track.dart';
import 'package:me_and_flora/core/presentation/widgets/buttons/track_button.dart';
import 'package:me_and_flora/core/presentation/widgets/plant_image.dart';

import '../../domain/models/models.dart';

class TrackPlantImage extends StatelessWidget {
  const TrackPlantImage({super.key, required this.plant, required this.iconSize});

  final Plant plant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PlantImage(image: plant.path, size: iconSize),
            Align(
              alignment: Alignment.topRight,
              child: BlocBuilder<PlantTrackBloc, PlantTrackState>(
                builder: (context, state) {
                  return TrackButton(plant: plant, size: height * width * 0.000074,);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
