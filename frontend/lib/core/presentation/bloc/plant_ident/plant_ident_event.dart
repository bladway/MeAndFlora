import 'package:equatable/equatable.dart';
import 'package:me_and_flora/core/domain/models/models.dart';

abstract class PlantIdentEvent extends Equatable {
  const PlantIdentEvent();

  @override
  List<Object> get props => [];
}

class PlantIdentRequested extends PlantIdentEvent {
  final String imagePath;

  const PlantIdentRequested(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class PlantBotanicIdentInitial extends PlantIdentEvent {
  const PlantBotanicIdentInitial();
}

class PlantBotanicIdentRequested extends PlantIdentEvent {
  final Plant plant;

  const PlantBotanicIdentRequested(this.plant);

  @override
  List<Object> get props => [plant];
}
