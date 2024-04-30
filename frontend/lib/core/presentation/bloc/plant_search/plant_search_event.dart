import 'package:equatable/equatable.dart';

abstract class PlantSearchEvent extends Equatable {
  const PlantSearchEvent();

  @override
  List<Object> get props => [];
}

class PlantSearchRequested extends PlantSearchEvent {
  final String plantName;

  const PlantSearchRequested(this.plantName);

  @override
  List<Object> get props => [plantName];
}
