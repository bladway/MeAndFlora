import 'package:equatable/equatable.dart';

abstract class PlantTrackListEvent extends Equatable {
  const PlantTrackListEvent();

  @override
  List<Object> get props => [];
}

class PlantTrackListRequested extends PlantTrackListEvent {
  final int page;
  final int size;

  const PlantTrackListRequested({this.page = 0, this.size = 100});
}

class PlantTrackListRequestedByAdmin extends PlantTrackListEvent {
  final int page;
  final int size;

  const PlantTrackListRequestedByAdmin({this.page = 0, this.size = 100});
}
