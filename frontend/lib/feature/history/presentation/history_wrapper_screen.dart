import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_ident_history/plant_ident_history.dart';

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
          ..add(const PlantHistoryListRequested(page: 0)),
        child: BlocListener<PlantIdentHistoryBloc, PlantIdentHistoryState>(
            listener: (BuildContext context, PlantIdentHistoryState state) {
              if (state is PlantAddToHistorySuccess) {
                BlocProvider.of<PlantHistoryBloc>(context)
                    .add(const PlantHistoryListRequested(page: 0));
              }
            },
            child: this));
  }
}
