import 'package:equatable/equatable.dart';

abstract class UnknownPlantsEvent extends Equatable {
  const UnknownPlantsEvent();

  @override
  List<Object> get props => [];
}

class UnknownPlantsRequested extends UnknownPlantsEvent {}