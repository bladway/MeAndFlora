import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantIdentState extends Equatable {
  const PlantIdentState();

  @override
  List<Object> get props => [];
}

class PlantIdentInitial extends PlantIdentState {}

class PlantSecondIdentInitial extends PlantIdentState {}

class PlantIdentLoadInProgress extends PlantIdentState {}

class PlantIdentLoadSuccess extends PlantIdentState {
  final Plant plant;

  const PlantIdentLoadSuccess({required this.plant});

  @override
  List<Object> get props => [plant];
}

class PlantSecondIdentSend extends PlantIdentState {
  final Plant plant;

  const PlantSecondIdentSend(this.plant);

  @override
  List<Object> get props => [plant];
}

class PlantIdentLimitReached extends PlantIdentState {}

class PlantIdentLoadFailure extends PlantIdentState {
  final String errorMsg;

  const PlantIdentLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
