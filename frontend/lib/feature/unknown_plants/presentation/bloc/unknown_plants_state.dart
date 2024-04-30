import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/models.dart';

abstract class UnknownPlantsState extends Equatable {
  const UnknownPlantsState();

  @override
  List<Object> get props => [];
}

class UnknownPlantsInitial extends UnknownPlantsState {}

class UnkonwPlantsLoadInProgress extends UnknownPlantsState {}

class UnknownPlantListSuccess extends UnknownPlantsState {
  final List<Plant> plants;

  const UnknownPlantListSuccess({required this.plants});
}

class UnknownPlantListFailture extends UnknownPlantsState {}