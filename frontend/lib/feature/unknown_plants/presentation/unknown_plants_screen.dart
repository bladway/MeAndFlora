import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/feature/unknown_plants/presentation/widgets/unknown_plant_element.dart';
import 'package:me_and_flora/feature/unknown_plants/presentation/widgets/unknown_plant_list.dart';

import 'bloc/unknown_plants.dart';

@RoutePage()
class UnknownPlantsScreen extends StatelessWidget {
  const UnknownPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Stack(children: [
      const Background(),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            'Неидентифицированные растения',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.merge(const TextStyle(fontSize: 19)),
          ),
        ),
        body: const UnknownPlantList(),
      ),
    ]);
  }
}
