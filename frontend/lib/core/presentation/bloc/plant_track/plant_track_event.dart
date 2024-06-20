import 'package:equatable/equatable.dart';

abstract class PlantTrackEvent extends Equatable {
  const PlantTrackEvent();

  @override
  List<Object> get props => [];
}

class PlantTrackRequested extends PlantTrackEvent {
  final String plantName;

  const PlantTrackRequested(this.plantName);
}
