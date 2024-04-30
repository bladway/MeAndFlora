import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantTrackState extends Equatable {
  const PlantTrackState();

  @override
  List<Object> get props => [];
}

class PlantTrackInitial extends PlantTrackState {}

class PlantTrackLoadInProgress extends PlantTrackState {}

class PlantTrackLoadSuccess extends PlantTrackState {}

class PlantTrackListLoadSuccess extends PlantTrackState {
  final List<Plant> plantList;

  const PlantTrackListLoadSuccess({required this.plantList});

  @override
  List<Object> get props => [plantList];
}

class PlantTrackLoadFailure extends PlantTrackState {
  final String errorMsg;

  const PlantTrackLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
