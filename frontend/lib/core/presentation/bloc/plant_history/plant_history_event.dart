import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantHistoryEvent extends Equatable {
  const PlantHistoryEvent();

  @override
  List<Object> get props => [];
}

class PlantHistoryListRequested extends PlantHistoryEvent {
  final int pageNumber;

  const PlantHistoryListRequested({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}

class PlantHistoryRequested extends PlantHistoryEvent {
  final Plant plant;

  const PlantHistoryRequested({required this.plant});

  @override
  List<Object> get props => [plant];
}
