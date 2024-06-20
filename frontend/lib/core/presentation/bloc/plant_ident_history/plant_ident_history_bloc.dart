import 'package:bloc/bloc.dart';

import 'plant_ident_history.dart';
import 'plant_ident_history_event.dart';

class PlantIdentHistoryBloc extends Bloc<PlantIdentHistoryEvent, PlantIdentHistoryState> {
  PlantIdentHistoryBloc() : super(PlantInitial()) {
    on<PlantIdentHistoryEvent>(
          (event, emit) async {
        if (event is AddPlantHistoryRequested) {
          await _requestAddPlantHistory(event, emit);
        }
      },
    );
  }

  Future<void> _requestAddPlantHistory(
      AddPlantHistoryRequested event, Emitter<PlantIdentHistoryState> emit) async {
    emit(PlantLoadInProgress());
    try {
      emit(PlantAddToHistorySuccess());
    } on Exception catch (_, e) {
      emit(PlantLoadFailure(errorMsg: e.toString()));
    }
  }
}
