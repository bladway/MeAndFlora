import 'package:equatable/equatable.dart';
import 'package:me_and_flora/core/domain/dto/geo_dto.dart';

abstract class PlantIdentEvent extends Equatable {
  const PlantIdentEvent();

  @override
  List<Object> get props => [];
}

class PlantIdentRequested extends PlantIdentEvent {
  final GeoDto? point;
  final String imagePath;

  const PlantIdentRequested({required this.point, required this.imagePath});
}

class UserIdentDecesionRequested extends PlantIdentEvent {
  final bool isCorrect;
  final int requestId;

  const UserIdentDecesionRequested(
      {required this.isCorrect, required this.requestId});
}

class PlantBotanicIdentInitial extends PlantIdentEvent {
  const PlantBotanicIdentInitial();
}

class PlantBotanicIdentRequested extends PlantIdentEvent {
  final bool isCorrect;
  final int requestId;

  const PlantBotanicIdentRequested(
      {required this.isCorrect, required this.requestId});
}
