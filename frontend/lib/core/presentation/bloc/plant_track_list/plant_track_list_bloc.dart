import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/track_service.dart';
import 'plant_track_list.dart';

class PlantTrackListBloc extends Bloc<PlantTrackListEvent, PlantTrackListState> {
  PlantTrackListBloc() : super(PlantTrackListInitial()) {
    on<PlantTrackListEvent>(
      (event, emit) async {
        if (event is PlantTrackListRequestedByAdmin) {
          await _requestTrackPlantListByAdmin(event, emit);
        }
        if (event is PlantTrackListRequested) {
          await _requestTrackPlantList(event, emit);
        }
      },
    );
  }

  Future<void> _requestTrackPlantListByAdmin(
      PlantTrackListRequestedByAdmin event,
      Emitter<PlantTrackListState> emit) async {
    emit(PlantTrackListLoadInProgress());
    try {
      final Map<int, Plant> plantList = await locator<TrackService>()
          .getTrackPlantsByAdmin(event.page, event.size);
      emit(PlantTrackListLoadSuccess(plantList: plantList.values.toList()));
    } on Exception catch (_, e) {
      emit(PlantTrackLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestTrackPlantList(
      PlantTrackListRequested event, Emitter<PlantTrackListState> emit) async {
    emit(PlantTrackListLoadInProgress());
    try {
      final Map<int, Plant> plantList = await locator<TrackService>()
          .getTrackPlantsByUser(event.page, event.size);
      emit(PlantTrackListLoadSuccess(plantList: plantList.values.toList()));
    } on Exception catch (_, e) {
      emit(PlantTrackLoadFailure(errorMsg: e.toString()));
    }
  }
}
