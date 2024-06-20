import 'package:bloc/bloc.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/history_service.dart';
import 'plant_history.dart';

class PlantHistoryBloc extends Bloc<PlantHistoryEvent, PlantHistoryState> {
  PlantHistoryBloc() : super(PlantInitial()) {
    on<PlantHistoryEvent>(
      (event, emit) async {
        if (event is PlantHistoryListRequested) {
          await _requestHistoryPlantList(event, emit);
        }
        if (event is PlantHistoryRequested) {
          await _requestPlantHistory(event, emit);
        }
      },
    );
  }

  Future<void> _requestHistoryPlantList(
      PlantHistoryListRequested event, Emitter<PlantHistoryState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList =
          await HistoryService().getHistoryPlants("", event.pageNumber);
      emit(PlantHistoryLoadSuccess(plantList: plantList));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestPlantHistory(
      PlantHistoryRequested event, Emitter<PlantHistoryState> emit) async {
    emit(PlantLoadInProgress());
    try {
      await HistoryService().addPlantToHistory("accountId", event.plant);
      emit(PlantLoadSuccess());
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }
}
