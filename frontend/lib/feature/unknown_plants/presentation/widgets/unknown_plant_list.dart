import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/core/presentation/widgets/empty_widget.dart';
import 'package:me_and_flora/feature/unknown_plants/presentation/bloc/unknown_plants.dart';
import 'package:me_and_flora/feature/unknown_plants/presentation/widgets/unknown_plant_element.dart';

class UnknownPlantList extends StatefulWidget {
  const UnknownPlantList({super.key});

  @override
  State<UnknownPlantList> createState() => _UnknownPlantListState();
}

class _UnknownPlantListState extends State<UnknownPlantList> {
  bool _isLastPage = false;
  int _pageNumber = 0;
  final int _nextPageTrigger = 2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    List<Plant> plants = [];
    List<int> plantIdList = [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<UnknownPlantsBloc, UnknownPlantsState>(
          builder: (context, state) {
        if (state is UnknownPlantsLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UnknownPlantListSuccess) {
          if (state.plants.isNotEmpty) {
            _pageNumber++;
            plants.addAll(state.plants);
            plantIdList.addAll(state.plantIdList);
          } else {
            _isLastPage = true;
            if (plants.isEmpty) {
              return const EmptyWidget();
            }
          }
        }
        return ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: plants.length + (_isLastPage ? 0 : 1),
          separatorBuilder: (BuildContext context, _) => SizedBox(
            height: height * 0.03,
          ),
          itemBuilder: (context, index) {
            if (index == plants.length - _nextPageTrigger && !_isLastPage) {
              BlocProvider.of<UnknownPlantsBloc>(context)
                  .add(UnknownPlantsRequested(page: _pageNumber));
            }
            if (index == plants.length) {
              _isLastPage = true;
              if (state is UnknownPlantsLoadInProgress) {
                return const CircularProgressIndicator();
              } else {
                return const Center();
              }
            }
            return UnknownPlantElement(
              requestId: plantIdList[index],
              plant: plants[index],
              iconSize: height * 0.3 * 0.3,
            );
          },
        );
      }),
    );
  }
}
