import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/feature/plant_public/presentation/widgets/plant_public_elemet.dart';

import '../../../core/presentation/bloc/plant_track/plant_track.dart';

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
        body: BlocBuilder<PlantTrackBloc, PlantTrackState>(
            builder: (context, state) {
          if (state is PlantTrackListLoadSuccess) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              itemCount: state.plantList.length,
              separatorBuilder: (BuildContext context, _) => SizedBox(
                height: height * 0.03,
              ),
              itemBuilder: (context, i) {
                return PlantPublicElement(
                  plant: state.plantList[i],
                  iconSize: height * 0.3 * 0.3,
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
