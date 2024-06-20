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
  final String imagePath;
  final int requestId;

  const PlantIdentLoadSuccess(
      {required this.plant, required this.imagePath, required this.requestId});

  @override
  List<Object> get props => [plant];
}

class PlantUserIdentSuccess extends PlantIdentState {}

class PlantIdentLimitReached extends PlantIdentState {}

class PlantIdentLoadFailure extends PlantIdentState {
  final String errorMsg;

  const PlantIdentLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
