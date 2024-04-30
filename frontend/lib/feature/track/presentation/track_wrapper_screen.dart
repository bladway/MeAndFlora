import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
        create: (context) => PlantTrackBloc()..add(PlantTrackListRequested()),
        child: this);
  }
}
