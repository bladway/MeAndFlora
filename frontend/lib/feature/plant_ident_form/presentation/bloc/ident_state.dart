import 'package:equatable/equatable.dart';

abstract class IdentState extends Equatable {
  const IdentState();

  @override
  List<Object> get props => [];
}

class IdentInitial extends IdentState {}

class IdentLoadInProgress extends IdentState {}

class ImpossibleIdent extends IdentState {}

class IdentSuccess extends IdentState {}

class IdentFailture extends IdentState {}
