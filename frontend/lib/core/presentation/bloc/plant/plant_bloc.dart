import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/service/history_service.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/track_service.dart';
import 'plant_event.dart';
import 'plant_state.dart';

class PlantBloc extends Bloc<PlantEvent, PlantState> {
  PlantBloc() : super(PlantInitial()) {
    on<PlantEvent>(
      (event, emit) async {
        if (event is HomePageRequested) {
          await _requestHomePage(event, emit);
        }
        if (event is FlowersRequested) {
          await _requestFlowerList(event, emit);
        }
        if (event is TreesRequested) {
          await _requestTreeList(event, emit);
        }
        if (event is GrassRequested) {
          await _requestGrassList(event, emit);
        }
        if (event is MossRequested) {
          await _requestMossList(event, emit);
        }
        if (event is PlantHistoryRequested) {
          await _requestPlantHistory(event, emit);
        }
        if (event is PlantTrackRequested) {
          await _requestPlantTrack(event, emit);
        }
      },
    );
  }

  Future<void> _requestHomePage(
      HomePageRequested event, Emitter<PlantState> emit) async {
    add(FlowersRequested());
    add(TreesRequested());
    add(GrassRequested());
    add(MossRequested());
  }

  Future<void> _requestFlowerList(
      FlowersRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getFlowers();
    emit(PlantLoadSuccess(plantList: plantList));
  }

  Future<void> _requestTreeList(
      TreesRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getTrees();
    emit(PlantLoadSuccess(plantList: plantList));
  }

  Future<void> _requestGrassList(
      GrassRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getGrass();
    emit(PlantLoadSuccess(plantList: plantList));
  }

  Future<void> _requestMossList(
      MossRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getMoss();
    emit(PlantLoadSuccess(plantList: plantList));
  }

  Future<void> _requestPlantHistory(
      PlantHistoryRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList = await HistoryService().getPlantHistory("");
      emit(PlantLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestPlantTrack(
      PlantTrackRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList = await TrackService().getPlantHistory("");
      emit(PlantLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }
}
