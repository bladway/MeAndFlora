import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantTrackListState extends Equatable {
  const PlantTrackListState();

  @override
  List<Object> get props => [];
}

class PlantTrackListInitial extends PlantTrackListState {}

class PlantTrackListLoadInProgress extends PlantTrackListState {}

class PlantTrackListLoadSuccess extends PlantTrackListState {
  final List<Plant> plantList;

  const PlantTrackListLoadSuccess({required this.plantList});

  @override
  List<Object> get props => [plantList];
}

class PlantTrackLoadFailure extends PlantTrackListState {
  final String errorMsg;

  const PlantTrackLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
