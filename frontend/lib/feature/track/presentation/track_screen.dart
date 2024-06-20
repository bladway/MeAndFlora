import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/feature/track/presentation/widgets/track_plant_list.dart';

@RoutePage()
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
