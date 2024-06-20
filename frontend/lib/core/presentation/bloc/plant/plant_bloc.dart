import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
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
        if (event is PlantRemoveRequested) {
          await _removePlant(event, emit);
        }
      },
    );
  }

  Future<void> _removePlant(
      PlantRemoveRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    try {
      await locator<PlantService>().removePublication(event.publicId);
      emit(PlantRemoveSuccess(id: event.publicId));
    } catch (e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestHomePage(
      HomePageRequested event, Emitter<PlantState> emit) async {
    add(const FlowersRequested());
    add(const TreesRequested());
    add(const GrassRequested());
    add(const MossRequested());
  }

  Future<void> _requestFlowerList(
      FlowersRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await locator<PlantService>().getFlowers(event.page, event.size);
    emit(PlantsLoadSuccess(plantList: plantList));
  }

  Future<void> _requestTreeList(
      TreesRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await locator<PlantService>().getTrees(event.page, event.size);
    emit(PlantsLoadSuccess(plantList: plantList));
  }

  Future<void> _requestGrassList(
      GrassRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await locator<PlantService>().getGrass(event.page, event.size);
    emit(PlantsLoadSuccess(plantList: plantList));
  }

  Future<void> _requestMossList(
      MossRequested event, Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = await locator<PlantService>().getMoss(event.page, event.size);
    emit(PlantsLoadSuccess(plantList: plantList));
  }
}
