import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class PlantState extends Equatable {
  const PlantState();

  @override
  List<Object> get props => [];
}

class PlantInitial extends PlantState {}

class PlantLoadInProgress extends PlantState {}

class PlantRemoveSuccess extends PlantState {
  final int id;

  const PlantRemoveSuccess({required this.id});
}

class PlantLoadSuccess extends PlantState {
  final Plant plant;

  const PlantLoadSuccess({required this.plant});

  @override
  List<Object> get props => [plant];
}

class PlantsLoadSuccess extends PlantState {
  final List<Plant> plantList;

  const PlantsLoadSuccess({required this.plantList});

  @override
  List<Object> get props => [plantList];
}

class AllPlantsLoadSuccess extends PlantState {
  final List<Plant> flowers;
  final List<Plant> trees;
  final List<Plant> grass;
  final List<Plant> moss;

  const AllPlantsLoadSuccess({
    required this.flowers,
    required this.trees,
    required this.grass,
    required this.moss,
  });

  @override
  List<Object> get props => [flowers, trees, grass, moss];
}

class PlantLoadFailure extends PlantState {
  final String errorMsg;

  const PlantLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
