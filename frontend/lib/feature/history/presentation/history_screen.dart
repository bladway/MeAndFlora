import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/core/theme/strings.dart';

import '../../../core/presentation/bloc/plant_history/plant_history.dart';
import 'widgets/plant_grid.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent('Переход на страницу истории');

    return Stack(children: [
        const Background(),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                history,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            body: BlocBuilder<PlantHistoryBloc, PlantHistoryState>(
                builder: (context, state) {
              if (state is PlantHistoryLoadSuccess) {
                if (state.plantList.isEmpty) {
                  return const Center();
                }
                return const PlantGrid();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        )
      ]
    );
  }
}
