import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_history/plant_history.dart';

import '../../../../core/domain/models/models.dart';
import 'history_plant_element.dart';

class PlantGrid extends StatefulWidget {
  const PlantGrid({super.key});

  @override
  State<PlantGrid> createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  late int _numberOfPostsPerRequest;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _isLastPage = false;
    _numberOfPostsPerRequest = 10;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        BlocProvider.of<PlantHistoryBloc>(context)
            .add(PlantHistoryListRequested(pageNumber: _pageNumber));
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<PlantHistoryBloc, PlantHistoryState>(
          builder: (context, state) {
        if (state is PlantHistoryLoadSuccess) {
          return GridView.builder(
            controller: _scrollController,
            itemCount: state.plantList.length + (_isLastPage ? 0 : 1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index == state.plantList.length) {
                _isLastPage = true;
                if (state is PlantLoadInProgress) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else {
                  return const Center();
                }
              }
              return HistoryPlantElement(
                  plant: state.plantList[index], iconSize: height * 0.3 * 0.15);
            },
          );
        }
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
        ));
      }),
    );
  }
}

/*
class PlantGrid extends StatelessWidget {
  final List<Plant> _plantList;
  //late ScrollController _scrollController;

  const PlantGrid({super.key, required List<Plant> plantList})
      : _plantList = plantList;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: _plantList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return HistoryPlantElement(plant: _plantList[index], iconSize: height * 0.3 * 0.15);
        },
      ),
    );
  }
}*/
