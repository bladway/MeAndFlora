import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/plant/plant.dart';
import '../../../core/presentation/bloc/plant_search/plant_search.dart';

@RoutePage()
class HomeWrapperScreen extends StatelessWidget implements AutoRouteWrapper {
  const HomeWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PlantBloc>(
        lazy: false,
        create: (context) => PlantBloc()..add(HomePageRequested()),
      ),
      BlocProvider<PlantSearchBloc>(
        lazy: false,
        create: (context) => PlantSearchBloc(),
      ),
    ], child: this);
  }
}
