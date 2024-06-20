import 'package:bloc/bloc.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/track_service.dart';
import 'plant_track.dart';

class PlantTrackBloc extends Bloc<PlantTrackEvent, PlantTrackState> {
  PlantTrackBloc() : super(PlantTrackInitial()) {
    on<PlantTrackEvent>(
          (event, emit) async {
        if (event is PlantTrackListRequested) {
          await _requestTrackPlantList(event, emit);
        }
        if (event is PlantTrackRequested) {
          await _requestPlantTrack(event, emit);
        }
      },
    );
  }

  Future<void> _requestTrackPlantList(
      PlantTrackListRequested event, Emitter<PlantTrackState> emit) async {
    emit(PlantTrackLoadInProgress());
    try {
      final List<Plant> plantList = await TrackService().getTrackPlants("");
      emit(PlantTrackListLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantTrackLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestPlantTrack(
      PlantTrackRequested event, Emitter<PlantTrackState> emit) async {
    emit(PlantTrackLoadInProgress());
    try {
      //await TrackService().trackPlant(event.login, event.plant);
      emit(PlantTrackLoadSuccess());
    } on Exception catch (_, e) {
      emit(PlantTrackLoadFailure(errorMsg: e.toString()));
    }
  }
}
