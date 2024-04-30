import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoadInProcess extends LocationState {}

class LocationLoadSuccess extends LocationState {
  final double lat;
  final double lon;

  const LocationLoadSuccess({required this.lat, required this.lon,});
}

class LocationLoadFailure extends LocationState {
  final String errorMsg;

  const LocationLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}