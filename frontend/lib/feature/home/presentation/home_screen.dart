import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../../core/presentation/bloc/plant/plant.dart';
import '../../../core/presentation/widgets/plant_list.dart';
import '../../../core/presentation/widgets/search_delegate.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return BlocProvider<PlantBloc>(
      lazy: false,
      create: (context) => PlantBloc()..add(HomePageRequested()),
      child: Stack(children: [
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 90, bottom: 70),
                    child: BlocBuilder<PlantBloc, PlantState>(
                        builder: (context, state) {
                      return TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'Поиск',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 24,
                            weight: 3,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: MySearchDelegate((query) =>
                                  BlocProvider.of<PlantBloc>(context)
                                    ..add(PlantDetailsRequested())));
                        },
                      );
                    }),
                  ),
                  BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
                    if (state is PlantLoadSuccess) {
                      return PlantList(
                        plantList: state.plantList,
                        title: 'Цветы',
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
                    if (state is PlantLoadSuccess) {
                      return PlantList(
                        plantList: state.plantList,
                        title: 'Деревья',
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
                    if (state is PlantLoadSuccess) {
                      return PlantList(
                        plantList: state.plantList,
                        title: 'Трава',
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
                    if (state is PlantLoadSuccess) {
                      return PlantList(
                        plantList: state.plantList,
                        title: 'Мох',
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
