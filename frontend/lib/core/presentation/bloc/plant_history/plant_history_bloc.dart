import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';

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
        // if (event is AddPlantHistoryRequested) {
        //   await _requestAddPlantHistory(event, emit);
        // }
      },
    );
  }

  Future<void> _requestHistoryPlantList(PlantHistoryListRequested event,
      Emitter<PlantHistoryState> emit) async {
    emit(PlantLoadInProgress());
    try {
      final List<Plant> plantList = await locator<HistoryService>()
          .getHistoryPlants(event.page, event.size);
      emit(PlantHistoryLoadSuccess(plantList: plantList, page: event.page));
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }

  // Future<void> _requestAddPlantHistory(
  //     AddPlantHistoryRequested event, Emitter<PlantHistoryState> emit) async {
  //   emit(PlantLoadInProgress());
  //   try {
  //     emit(PlantAddToHistorySuccess());
  //   } on Exception catch (_, e) {
  //     emit(PlantLoadFailure(errorMsg: e.toString()));
  //   }
  // }
}
