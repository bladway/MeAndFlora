import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/domain/service/track_service.dart';
import 'package:me_and_flora/core/presentation/bloc/plant/plant.dart';
import 'package:me_and_flora/core/presentation/widgets/widgets.dart';
import 'package:me_and_flora/feature/plant_public/presentation/widgets/plant_public_elemet.dart';

class PlantPublicList extends StatefulWidget {
  const PlantPublicList({super.key});

  @override
  State<PlantPublicList> createState() => _PlantPublicListState();
}

class _PlantPublicListState extends State<PlantPublicList> {
  bool _isLastPage = false;
  int _pageNumber = 0;
  final int _size = 100;
  final int _nextPageTrigger = 2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    List<int> requestIds = [];
    List<Plant> plants = [];

    return StreamBuilder<Map<int, Plant>>(
      stream: locator<TrackService>().getStreamTrackPlantsByAdmin(
          _pageNumber, _size, const Duration(minutes: 1)),
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
            return BlocListener<PlantBloc, PlantState>(
              listener: (BuildContext context, PlantState state) {
                if (state is PlantRemoveSuccess) {
                  // int index = requestIds.indexOf(state.id);
                  // requestIds.removeAt(index);
                  // plants.removeAt(index);
                  const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: plants.length + (_isLastPage ? 0 : 1),
                separatorBuilder: (BuildContext context, _) => SizedBox(
                  height: height * 0.03,
                ),
                itemBuilder: (context, index) {
                  if (index == plants.length - _nextPageTrigger &&
                      !_isLastPage) {
                    _pageNumber++;
                  }
                  if (index == plants.length) {
                    _isLastPage = true;
                  }
                  return index == plants.length
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PlantPublicElement(
                          requestId: requestIds[index],
                          plant: plants[index],
                          iconSize: height * 0.3 * 0.3,
                        );
                },
              ),
            );
          }
        }
      },
    );

    // return BlocListener<PlantTrackBloc, PlantTrackState>(
    //   listener: (BuildContext context, PlantTrackState state) {
    //     if (state is PlantTrackLoadSuccess) {
    //       plants = [];
    //       BlocProvider.of<PlantTrackListBloc>(context)
    //           .add(const PlantTrackListRequested());
    //     }
    //   },
    //   child: BlocBuilder<PlantTrackListBloc, PlantTrackListState>(
    //       builder: (context, state) {
    //     if (state is PlantTrackListLoadInProgress) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     if (state is PlantTrackListLoadSuccess) {
    //       if (state.plantList.isNotEmpty) {
    //         _pageNumber++;
    //         plants.addAll(state.plantList);
    //       } else if (plants.isEmpty) {
    //         return const EmptyWidget();
    //       }
    //     }
    //     return BlocListener<PlantBloc, PlantState>(
    //       listener: (BuildContext context, PlantState state) {
    //         if (state is PlantRemoveSuccess) {
    //           plants = [];
    //           BlocProvider.of<PlantTrackListBloc>(context)
    //               .add(const PlantTrackListRequestedByAdmin());
    //         }
    //       },
    //       child: ListView.separated(
    //         scrollDirection: Axis.vertical,
    //         itemCount: plants.length + (_isLastPage ? 0 : 1),
    //         separatorBuilder: (BuildContext context, _) => SizedBox(
    //           height: height * 0.03,
    //         ),
    //         itemBuilder: (context, index) {
    //           if (plants.length == 100 &&
    //               index == plants.length - _nextPageTrigger &&
    //               !_isLastPage) {
    //             BlocProvider.of<PlantTrackListBloc>(context)
    //                 .add(PlantTrackListRequestedByAdmin(page: _pageNumber));
    //           }
    //           if (index == plants.length) {
    //             _isLastPage = true;
    //             if (state is PlantTrackLoadInProgress) {
    //               return const CircularProgressIndicator();
    //             } else {
    //               return const Center();
    //             }
    //           }
    //           return PlantPublicElement(
    //             plant: plants[index],
    //             iconSize: height * 0.3 * 0.3,
    //           );
    //         },
    //       ),
    //     );
    //   }),
    // );
  }
}
