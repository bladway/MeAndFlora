import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/bloc/plant/plant.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_track_list/plant_track_list.dart';

import '../../../core/presentation/bloc/plant_track/plant_track.dart';

@RoutePage()
class TrackWrapperScreen extends StatelessWidget implements AutoRouteWrapper {
  const TrackWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PlantTrackBloc>(
        lazy: false,
        create: (context) => PlantTrackBloc(),
      ),
      BlocProvider<PlantTrackListBloc>(
        lazy: false,
        create: (context) => PlantTrackListBloc()..add(const PlantTrackListRequested()),
      ),
      BlocProvider<PlantBloc>(lazy: false, create: (context) => PlantBloc()),
    ], child: this);
  }
}
