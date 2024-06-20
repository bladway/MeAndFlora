import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/unknown_plants.dart';

@RoutePage()
class UnknownPlantsWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  const UnknownPlantsWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
        create: (context) => UnknownPlantsBloc()..add(const UnknownPlantsRequested()),
        child: this);
  }
}
