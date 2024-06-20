import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/models.dart';

abstract class UnknownPlantsState extends Equatable {
  const UnknownPlantsState();

  @override
  List<Object> get props => [];
}

class UnknownPlantsInitial extends UnknownPlantsState {}

class UnknownPlantsLoadInProgress extends UnknownPlantsState {}

class UnknownPlantListSuccess extends UnknownPlantsState {
  final List<int> plantIdList;
  final List<Plant> plants;

  const UnknownPlantListSuccess({required this.plantIdList, required this.plants});
}

class UnknownPlantListFailture extends UnknownPlantsState {}