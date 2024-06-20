import 'package:equatable/equatable.dart';

abstract class UnknownPlantsEvent extends Equatable {
  const UnknownPlantsEvent();

  @override
  List<Object> get props => [];
}

class UnknownPlantsRequested extends UnknownPlantsEvent {
  final int page;
  final int size;

  const UnknownPlantsRequested({this.page = 0, this.size = 100});
}