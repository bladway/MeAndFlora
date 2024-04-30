import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantTrackEvent extends Equatable {
  const PlantTrackEvent();

  @override
  List<Object> get props => [];
}

class PlantTrackListRequested extends PlantTrackEvent {
}

class PlantTrackRequested extends PlantTrackEvent {
  final Plant plant;

  const PlantTrackRequested(this.plant);

  @override
  List<Object> get props => [plant];
}
