import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantHistoryState extends Equatable {
  const PlantHistoryState();

  @override
  List<Object> get props => [];
}

class PlantInitial extends PlantHistoryState {}

class PlantLoadInProgress extends PlantHistoryState {}

class PlantLoadSuccess extends PlantHistoryState {}

class PlantHistoryLoadSuccess extends PlantHistoryState {
  final List<Plant> plantList;

  const PlantHistoryLoadSuccess({required this.plantList});

  @override
  List<Object> get props => [plantList];
}

class PlantLoadFailure extends PlantHistoryState {
  final String errorMsg;

  const PlantLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
