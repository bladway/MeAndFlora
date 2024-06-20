import 'package:equatable/equatable.dart';

abstract class PlantIdentHistoryState extends Equatable {
  const PlantIdentHistoryState();

  @override
  List<Object> get props => [];
}

class PlantInitial extends PlantIdentHistoryState {}

class PlantLoadInProgress extends PlantIdentHistoryState {}

class PlantAddToHistorySuccess extends PlantIdentHistoryState {}

class PlantLoadFailure extends PlantIdentHistoryState {
  final String errorMsg;

  const PlantLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
