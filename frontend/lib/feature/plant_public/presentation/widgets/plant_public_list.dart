import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/core/presentation/bloc/plant/plant.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_track_list/plant_track_list.dart';
import 'package:me_and_flora/core/presentation/widgets/widgets.dart';
import 'package:me_and_flora/feature/plant_public/presentation/widgets/plant_public_elemet.dart';

import '../../../../core/presentation/bloc/plant_track/plant_track.dart';

class PlantPublicList extends StatefulWidget {
  const PlantPublicList({super.key});

  @override
  State<PlantPublicList> createState() => _PlantPublicListState();
}

class _PlantPublicListState extends State<PlantPublicList> {
  bool _isLastPage = false;
  int _pageNumber = 0;
  final int _nextPageTrigger = 2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    List<Plant> plants = [];

    return BlocBuilder<PlantTrackListBloc, PlantTrackListState>(
        builder: (context, state) {
      if (state is PlantTrackListLoadInProgress) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is PlantTrackListLoadSuccess) {
        if (state.plantList.isNotEmpty) {
          _pageNumber++;
          plants.addAll(state.plantList);
        } else if (plants.isEmpty) {
          return const EmptyWidget();
        }
      }
      return BlocListener<PlantBloc, PlantState>(
        listener: (BuildContext context, PlantState state) {
          if (state is PlantRemoveSuccess) {
            plants = [];
            BlocProvider.of<PlantTrackListBloc>(context)
                .add(const PlantTrackListRequestedByAdmin());
          }
        },
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: plants.length + (_isLastPage ? 0 : 1),
          separatorBuilder: (BuildContext context, _) => SizedBox(
            height: height * 0.03,
          ),
          itemBuilder: (context, index) {
            if (index == plants.length - _nextPageTrigger && !_isLastPage) {
              BlocProvider.of<PlantTrackListBloc>(context)
                  .add(PlantTrackListRequestedByAdmin(page: _pageNumber));
            }
            if (index == plants.length) {
              _isLastPage = true;
              if (state is PlantTrackLoadInProgress) {
                return const CircularProgressIndicator();
              } else {
                return const Center();
              }
            }
            return PlantPublicElement(
              plant: plants[index],
              iconSize: height * 0.3 * 0.3,
            );
          },
        ),
      );
    });
  }
}