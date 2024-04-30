import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/models.dart';

abstract class IdentEvent extends Equatable {
  const IdentEvent();

  @override
  List<Object> get props => [];
}

class IdentRequested extends IdentEvent {
  final Plant plant;

  const IdentRequested({required this.plant});
}

class ImpossibleIdentRequested extends IdentEvent {
  final Plant plant;

  const ImpossibleIdentRequested({required this.plant});
}
