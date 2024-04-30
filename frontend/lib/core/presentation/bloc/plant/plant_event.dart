import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantEvent extends Equatable {
  const PlantEvent();

  @override
  List<Object> get props => [];
}

class HomePageRequested extends PlantEvent {}

class FlowersRequested extends PlantEvent {}

class TreesRequested extends PlantEvent {}

class GrassRequested extends PlantEvent {}

class MossRequested extends PlantEvent {}

class PlantNameRequested extends PlantEvent {}

class PlantDetailsRequested extends PlantEvent {}

class PlantRemoveRequested extends PlantEvent {
  final Plant plant;

  const PlantRemoveRequested({required this.plant});
}

/*
class PlantTrackListRequested extends PlantEvent {
}

class PlantTrackRequested extends PlantEvent {
  final Plant plant;

  const PlantTrackRequested(this.plant);

  @override
  List<Object> get props => [plant];
}

class PlantHistoryListRequested extends PlantEvent {
}

class PlantHistoryRequested extends PlantEvent {
  final Plant plant;

  const PlantHistoryRequested(this.plant);

  @override
  List<Object> get props => [plant];
}

class PlantSearchRequested extends PlantEvent {
  final String plantName;

  const PlantSearchRequested(this.plantName);

  @override
  List<Object> get props => [plantName];
}*/
