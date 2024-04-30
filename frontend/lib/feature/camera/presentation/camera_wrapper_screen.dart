import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/plant_ident/plant_ident.dart';
import 'bloc/bloc.dart';

@RoutePage()
class CameraWrapperScreen extends StatelessWidget implements AutoRouteWrapper {
  const CameraWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlantIdentBloc>(
            lazy: false, create: (_) => PlantIdentBloc()),
        BlocProvider<CameraBloc>(lazy: false, create: (_) => CameraBloc()),
        BlocProvider<LocationBloc>(
            lazy: false,
            create: (_) => LocationBloc()),
      ],
      child: this,
    );
  }
}
