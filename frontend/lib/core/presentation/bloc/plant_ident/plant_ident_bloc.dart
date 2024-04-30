import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/exception/ident_limit_exception.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/plant_service.dart';
import 'plant_ident.dart';

class PlantIdentBloc extends Bloc<PlantIdentEvent, PlantIdentState> {
  PlantIdentBloc() : super(PlantIdentInitial()) {
    on<PlantIdentEvent>(
      (event, emit) async {
        if (event is PlantIdentRequested) {
          await _requestPlantSearch(event, emit);
        }
        if (event is PlantBotanicIdentRequested) {
          await _requestPlantSearchByBotanic(event, emit);
        }
        if (event is PlantBotanicIdentInitial) {
          await _initialSearchByBotanic(event, emit);
        }
      },
    );
  }

  Future<void> _requestPlantSearch(
      PlantIdentRequested event, Emitter<PlantIdentState> emit) async {
    emit(PlantIdentLoadInProgress());
    try {
      final Plant plant =
          await PlantService().findPlantByPhoto(event.imagePath);
      emit(PlantIdentLoadSuccess(plant: plant));
    } on IdentLimitException catch (_) {
      emit(PlantIdentLimitReached());
    } on Exception catch (_, e) {
      emit(PlantIdentLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _initialSearchByBotanic(
      PlantBotanicIdentInitial event, Emitter<PlantIdentState> emit) async {
    emit(PlantSecondIdentInitial());
  }

  Future<void> _requestPlantSearchByBotanic(
      PlantBotanicIdentRequested event, Emitter<PlantIdentState> emit) async {
    emit(PlantSecondIdentInitial());
    try {
      PlantService().identByBotanic(event.plant.imageUrl);
      emit(PlantSecondIdentSend(event.plant));
    } on Exception catch (_, e) {
      emit(PlantIdentLoadFailure(errorMsg: e.toString()));
    }
  }
}
