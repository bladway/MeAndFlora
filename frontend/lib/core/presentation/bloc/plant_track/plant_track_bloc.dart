import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';

import '../../../domain/service/track_service.dart';
import 'plant_track.dart';

class PlantTrackBloc extends Bloc<PlantTrackEvent, PlantTrackState> {
  PlantTrackBloc() : super(PlantTrackInitial()) {
    on<PlantTrackEvent>(
      (event, emit) async {
        if (event is PlantTrackRequested) {
          await _requestPlantTrack(event, emit);
        }
      },
    );
  }

  Future<void> _requestPlantTrack(
      PlantTrackRequested event, Emitter<PlantTrackState> emit) async {
    emit(PlantTrackLoadInProgress());
    try {
      await locator<TrackService>().trackPlant(event.plantName);
      emit(PlantTrackLoadSuccess());
    } on Exception catch (_, e) {
      emit(PlantTrackLoadFailure(errorMsg: e.toString()));
    }
  }
}
