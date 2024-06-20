import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/plant_service.dart';

import 'ident.dart';

class IdentBloc extends Bloc<IdentEvent, IdentState> {
  IdentBloc() : super(IdentInitial()) {
    on<IdentEvent>((event, emit) async {
        if (event is IdentRequested) {
          await _identPlant(event, emit);
        }
        if (event is ImpossibleIdentRequested) {
          _impossibleIdentPlant(event, emit);
        }
      },
    );
  }

  _identPlant(
      IdentRequested event, Emitter<IdentState> emit) async {
    emit(IdentLoadInProgress());
    try {
      await PlantService().addPlant(event.plant);
      emit(IdentSuccess());
    } catch (e) {
      emit(IdentFailture());
    }
  }

  _impossibleIdentPlant(
      ImpossibleIdentRequested event, Emitter<IdentState> emit) async {
    emit(IdentLoadInProgress());
    try {
      await PlantService().addPlant(event.plant);
      emit(ImpossibleIdent());
    } catch (e) {
      emit(IdentFailture());
    }
  }
}
