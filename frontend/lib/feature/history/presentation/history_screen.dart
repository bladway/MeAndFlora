import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/core/theme/strings.dart';

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
            body: const PlantGrid()
          ),
        )
      ]
    );
  }
}
