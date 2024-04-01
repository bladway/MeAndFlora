import 'package:equatable/equatable.dart';

abstract class PlantEvent extends Equatable {
  const PlantEvent();

  @override
  List<Object> get props => [];
}

class PlantHomePageRequested extends PlantEvent {
}

class PlantNameRequested extends PlantEvent {
}

class PlantDetailsRequested extends PlantEvent {
}
