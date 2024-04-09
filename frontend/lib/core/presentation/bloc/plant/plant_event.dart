import 'package:equatable/equatable.dart';

abstract class PlantEvent extends Equatable {
  const PlantEvent();

  @override
  List<Object> get props => [];
}

class HomePageRequested extends PlantEvent {
}

class FlowersRequested extends PlantEvent {
}

class TreesRequested extends PlantEvent {
}

class GrassRequested extends PlantEvent {
}

class MossRequested extends PlantEvent {
}

class PlantNameRequested extends PlantEvent {
}

class PlantDetailsRequested extends PlantEvent {
}

class PlantTrackRequested extends PlantEvent {
}

class PlantHistoryRequested extends PlantEvent {
}
