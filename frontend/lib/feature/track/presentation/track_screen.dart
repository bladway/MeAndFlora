import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/feature/track/presentation/widgets/track_plant_list.dart';

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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                'Отслеживаемые растения',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            body: const TrackPlantList()
          ),
    ]);
  }
}
