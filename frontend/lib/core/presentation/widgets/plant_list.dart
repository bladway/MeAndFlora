import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/plant_type.dart';

import '../bloc/plant/plant.dart';
import 'plant_element.dart';

class PlantList extends StatelessWidget {
  const PlantList({super.key, required this.type});

  final PlantType type;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocProvider<PlantBloc>(
      lazy: false,
      create: (_) {
        if (type == PlantType.flower) {
          return PlantBloc()..add(FlowersRequested());
        } else if (type == PlantType.tree) {
          return PlantBloc()..add(TreesRequested());
        } else if (type == PlantType.grass) {
          return PlantBloc()..add(GrassRequested());
        } else if (type == PlantType.moss) {
          return PlantBloc()..add(MossRequested());
        }
        return PlantBloc();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.displayTitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(
            height: height * 0.005,
          ),
          SizedBox(
            height: height * 0.22,
            child:
                BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
              if (state is PlantsLoadSuccess) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.plantList.length,
                  separatorBuilder: (BuildContext context, _) => SizedBox(
                    width: width * 0.05,
                  ),
                  itemBuilder: (context, i) {
                    final plant = state.plantList[i];
                    return PlantElement(
                      plant: plant,
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
