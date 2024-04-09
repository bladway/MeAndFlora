import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/plant/plant.dart';
import 'widgets/plant_grid.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      create: (context) => PlantBloc()..add(PlantHistoryRequested()),
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
              SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    title: Text(
                      'История',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  body: PlantGrid(
                    plantList: state.plantList,
                  ),
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
