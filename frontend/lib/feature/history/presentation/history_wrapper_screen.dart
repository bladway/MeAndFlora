import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/plant_history/plant_history.dart';

@RoutePage()
class HistoryWrapperScreen extends StatelessWidget implements AutoRouteWrapper {
  const HistoryWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
        create: (context) => PlantHistoryBloc()
          ..add(const PlantHistoryListRequested(pageNumber: 0)),
        child: BlocListener<PlantHistoryBloc, PlantHistoryState>(
            listener: (BuildContext context, PlantHistoryState state) {
              if (state is PlantLoadSuccess) {
                BlocProvider.of<PlantHistoryBloc>(context)
                    .add(const PlantHistoryListRequested(pageNumber: 0));
              }
            },
            child: this));
  }
}
