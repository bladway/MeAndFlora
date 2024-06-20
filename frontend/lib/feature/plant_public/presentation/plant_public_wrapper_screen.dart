import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/plant/plant.dart';
import '../../../core/presentation/bloc/plant_track/plant_track.dart';

@RoutePage()
class PlantPublicWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  const PlantPublicWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PlantTrackBloc>(
        lazy: false,
        create: (context) => PlantTrackBloc()..add(PlantTrackListRequested()),
      ),
      BlocProvider<PlantBloc>(lazy: false, create: (context) => PlantBloc()),
    ], child: this);
  }
}
