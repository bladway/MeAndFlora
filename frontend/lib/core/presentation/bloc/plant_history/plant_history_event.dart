import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantHistoryEvent extends Equatable {
  const PlantHistoryEvent();

  @override
  List<Object> get props => [];
}

class PlantHistoryListRequested extends PlantHistoryEvent {
  final int page;
  final int size;

  const PlantHistoryListRequested({this.size = 100, required this.page});

  @override
  List<Object> get props => [page];
}

// class PlantHistoryRequested extends PlantHistoryEvent {
//   final Plant plant;
//
//   const PlantHistoryRequested({required this.plant});
//
//   @override
//   List<Object> get props => [plant];
// }
