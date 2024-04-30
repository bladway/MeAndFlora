import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';

import '../../../core/presentation/bloc/plant/plant.dart';
import '../../../core/presentation/bloc/plant_track/plant_track.dart';
import 'widgets/track_plant_element.dart';

@RoutePage()
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Stack(children: [
      const Background(),
      BlocBuilder<PlantTrackBloc, PlantTrackState>(builder: (context, state) {
        if (state is PlantTrackLoadSuccess) {
          BlocProvider.of<PlantTrackBloc>(context)
              .add(PlantTrackListRequested());
        }
        if (state is PlantTrackListLoadSuccess) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                'Отслеживаемые растения',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            body: ListView.separated(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              itemCount: state.plantList.length,
              separatorBuilder: (BuildContext context, _) => SizedBox(
                height: height * 0.03,
              ),
              itemBuilder: (context, i) {
                final plant = state.plantList[i];
                return TrackPlantElement(
                  plant: plant,
                  iconSize: height * 0.3 * 0.3,
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    ]);
  }
}
