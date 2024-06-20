import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';

import 'ident.dart';

class IdentBloc extends Bloc<IdentEvent, IdentState> {
  IdentBloc() : super(IdentInitial()) {
    on<IdentEvent>(
      (event, emit) async {
        if (event is IdentRequested) {
          await _identPlant(event, emit);
        }
        if (event is PlantCreateRequested) {
          await _createPlant(event, emit);
        }
        if (event is ImpossibleIdentRequested) {
          await _impossibleIdentPlant(event, emit);
        }
      },
    );
  }

  _identPlant(IdentRequested event, Emitter<IdentState> emit) async {
    emit(IdentLoadInProgress());
    try {
      await locator<PlantService>().sendBotanicDecision(event.requestId, event.name);
      emit(IdentSuccess());
    } catch (e) {
      emit(IdentFailture());
    }
  }

  _createPlant(PlantCreateRequested event, Emitter<IdentState> emit) async {
    emit(IdentLoadInProgress());
    try {
      await locator<PlantService>().sendSuccessIdentDecision(event.requestId, event.plant);
      emit(IdentSuccess());
    } catch (e) {
      emit(IdentFailture());
    }
  }

  _impossibleIdentPlant(
      ImpossibleIdentRequested event, Emitter<IdentState> emit) async {
    emit(IdentLoadInProgress());
    try {
      await locator<PlantService>().sendImpossibleIdentDecision(event.requestId);
      emit(ImpossibleIdent());
    } catch (e) {
      emit(IdentFailture());
    }
  }
}
