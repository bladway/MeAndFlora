import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/feature/plant_public/presentation/widgets/plant_public_list.dart';

@RoutePage()
class PlantPublicScreen extends StatelessWidget {
  const PlantPublicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    AppMetrica.reportEvent('Переход на страницу публикаций');

    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            'Публикации фотографий',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(10.0),
          child: PlantPublicList(),
        )
    );
  }
}
