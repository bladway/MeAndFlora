import 'package:equatable/equatable.dart';

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

// class AddPlantHistoryRequested extends PlantHistoryEvent {
//   const AddPlantHistoryRequested();
// }
