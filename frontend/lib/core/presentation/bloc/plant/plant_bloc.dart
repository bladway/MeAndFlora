import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';

import '../../../domain/models/models.dart';
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
        if (event is PlantRemoveRequested) {}
      },
    );
  }

  Future<void> _removePlant(
      PlantRemoveRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      await PlantService().removePlant(event.plant);
      emit(PlantRemoveSuccess());
    } catch (e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
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
    emit(PlantsLoadSuccess(plantList: plantList));
  }

  Future<void> _requestTreeList(
      TreesRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getTrees();
    emit(PlantsLoadSuccess(plantList: plantList));
  }

  Future<void> _requestGrassList(
      GrassRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getGrass();
    emit(PlantsLoadSuccess(plantList: plantList));
  }

  Future<void> _requestMossList(
      MossRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await PlantService().getMoss();
    emit(PlantsLoadSuccess(plantList: plantList));
  }

/*
  Future<void> _requestHistoryPlantList(
      PlantHistoryListRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList = await HistoryService().getHistoryPlants("");
      emit(PlantsLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestTrackPlantList(
      PlantTrackListRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList = await TrackService().getTrackPlants("accountId");
      emit(PlantsLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestPlantHistory(
      PlantHistoryRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      await HistoryService().addPlantToHistory("accountId", event.plant);
      final Plant plant = await HistoryService().getHistoryPlants("");
      emit(PlantLoadSuccess(plant: plant));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestPlantTrack(
      PlantTrackRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList = await TrackService().getTrackPlants("accountId");
      emit(PlantsLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestPlantSearch(
      PlantSearchRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final Plant plant = await PlantService().findPlantByName(event.plantName);
      emit(PlantLoadSuccess(plant: plant));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }*/
}
