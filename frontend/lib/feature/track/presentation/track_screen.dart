import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/plant/plant.dart';
import 'widgets/track_plant_element.dart';

@RoutePage()
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      create: (context) => PlantBloc()..add(PlantTrackRequested()),
      child: BlocBuilder<PlantBloc, PlantState>(
        builder: (context, state) {
          if (state is PlantLoadSuccess) {
            return Stack(children: [
              Image.asset(
                "assets/images/homeBackground.png",
                height: height * 0.5,
                width: width,
                fit: BoxFit.cover,
              ),
              Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black])),
              ),
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
                body: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  itemCount: state.plantList.length,
                  separatorBuilder: (BuildContext context, _) => SizedBox(height: height * 0.02,),
                  itemBuilder: (context, i) {
                    final plant = state.plantList[i];
                    return TrackPlantElement(plant: plant, iconSize: height * 0.3 * 0.3,);
                  },
                ),
              ),
            ]);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
