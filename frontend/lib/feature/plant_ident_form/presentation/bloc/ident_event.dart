import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/models.dart';

abstract class IdentEvent extends Equatable {
  const IdentEvent();

  @override
  List<Object> get props => [];
}

class PlantCreateRequested extends IdentEvent {
  final Plant plant;
  final int requestId;

  const PlantCreateRequested(
      {required this.plant, required this.requestId});
}

class IdentRequested extends IdentEvent {
  final String name;
  final int requestId;

  const IdentRequested({required this.name, required this.requestId});
}

class ImpossibleIdentRequested extends IdentEvent {
  final int requestId;

  const ImpossibleIdentRequested({required this.requestId});
}
