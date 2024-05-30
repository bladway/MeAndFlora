import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantEvent extends Equatable {
  const PlantEvent();

  @override
  List<Object> get props => [];
}

class HomePageRequested extends PlantEvent {}

class FlowersRequested extends PlantEvent {
  final int page;
  final int size;

  const FlowersRequested({this.page = 0, this.size = 10});
}

class TreesRequested extends PlantEvent {
  final int page;
  final int size;

  const TreesRequested({this.page = 0, this.size = 10});
}

class GrassRequested extends PlantEvent {
  final int page;
  final int size;

  const GrassRequested({this.page = 0, this.size = 10});
}

class MossRequested extends PlantEvent {
  final int page;
  final int size;

  const MossRequested({this.page = 0, this.size = 10});
}

class PlantNameRequested extends PlantEvent {
  final String name;

  const PlantNameRequested({required this.name});
}

class PlantDetailsRequested extends PlantEvent {}

class PlantRemoveRequested extends PlantEvent {
  final int publicId;

  const PlantRemoveRequested({required this.publicId});
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
