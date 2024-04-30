import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantSearchState extends Equatable {
  const PlantSearchState();

  @override
  List<Object> get props => [];
}

class PlantSearchInitial extends PlantSearchState {}

class PlantSearchLoadInProgress extends PlantSearchState {}

class PlantSearchLoadSuccess extends PlantSearchState {
  final Plant plant;

  const PlantSearchLoadSuccess({required this.plant});

  @override
  List<Object> get props => [plant];
}

class PlantSearchLoadFailure extends PlantSearchState {
  final String errorMsg;

  const PlantSearchLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
