import 'package:equatable/equatable.dart';

abstract class PlantIdentHistoryEvent extends Equatable {
  const PlantIdentHistoryEvent();

  @override
  List<Object> get props => [];
}

class AddPlantHistoryRequested extends PlantIdentHistoryEvent {
  const AddPlantHistoryRequested();
}
