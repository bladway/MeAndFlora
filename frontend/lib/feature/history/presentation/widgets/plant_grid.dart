import 'package:flutter/material.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/core/domain/service/history_service.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/presentation/widgets/widgets.dart';

import 'history_plant_element.dart';

class PlantGrid extends StatefulWidget {
  const PlantGrid({super.key});

  @override
  State<PlantGrid> createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  bool _isLastPage = false;
  int _pageNumber = 0;
  final int _size = 100;
  final int _nextPageTrigger = 3;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    List<int> requestIds = [];
    List<Plant> plants = [];

    return StreamBuilder<Map<int, Plant>>(
      stream: locator<HistoryService>()
        .getStreamHistoryPlants(_pageNumber, _size, const Duration(seconds: 10)),
      builder: (_, AsyncSnapshot<Map<int, Plant>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Что-то пошло не так :(',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          if (snapshot.data == null || snapshot.data?.length != _size) {
            _isLastPage = true;
          }
          if (snapshot.data?.isEmpty ?? true && plants.isEmpty) {
            return const EmptyWidget();
          } else {
            final data = snapshot.data;
            if (_isLastPage && plants.isNotEmpty) {
              int reloadCount = plants.length % _size;
              requestIds.replaceRange(requestIds.length - reloadCount - 1,
                  requestIds.length, data?.keys ?? []);
              plants.replaceRange(plants.length - reloadCount - 1,
                  plants.length, data?.values ?? []);
            } else if (plants.isEmpty) {
              requestIds.addAll(data?.keys ?? []);
              plants.addAll(data?.values ?? []);
            }
            return GridView.builder(
              itemCount: plants.length + (_isLastPage ? 0 : 1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (index == plants.length - _nextPageTrigger && !_isLastPage) {
                  _pageNumber++;
                }
                if (index == plants.length) {
                  _isLastPage = true;
                }
                return index == plants.length
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : HistoryPlantElement(
                        plant: plants[index], iconSize: height * 0.3 * 0.15);
              },
            );
          }
        }
      },
    );
  }
}
