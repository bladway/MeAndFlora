import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/dto/ident_response_dto.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/exception/ident_limit_exception.dart';

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
        if (event is UserIdentDecesionRequested) {
          await _requestUserDecesion(event, emit);
        }
        // if (event is PlantBotanicIdentInitial) {
        //   await _initialSearchByBotanic(event, emit);
        // }
      },
    );
  }

  Future<void> _requestPlantSearch(
      PlantIdentRequested event, Emitter<PlantIdentState> emit) async {
    emit(PlantIdentLoadInProgress());
    try {
      final IdentResponseDto identResponse = await locator<PlantService>()
          .findPlantByPhoto(event.point, event.imagePath);
      emit(PlantIdentLoadSuccess(
          plant: identResponse.floraDto,
          imagePath: event.imagePath,
          requestId: identResponse.requestId));
    } on IdentLimitException catch (_) {
      emit(PlantIdentLimitReached());
    } on Exception catch (_, e) {
      emit(PlantIdentLoadFailure(errorMsg: e.toString()));
    }
  }

  Future<void> _requestUserDecesion(
      UserIdentDecesionRequested event, Emitter<PlantIdentState> emit) async {
    emit(PlantIdentLoadInProgress());
    try {
      if (event.isCorrect) {
        await locator<PlantService>().sendUserCorrectDecision(event.requestId);
    } else {
        await locator<PlantService>().sendUserIncorrectDecision(event.requestId);
      }
      //emit(PlantBotanicIdentInitial());
    } on IdentLimitException catch (_) {
      emit(PlantIdentLimitReached());
    } on Exception catch (_, e) {
      emit(PlantIdentLoadFailure(errorMsg: e.toString()));
    }
  }

  // Future<void> _initialSearchByBotanic(
  //     PlantBotanicIdentInitial event, Emitter<PlantIdentState> emit) async {
  //   emit(PlantSecondIdentInitial());
  // }

  Future<void> _requestPlantSearchByBotanic(
      PlantBotanicIdentRequested event, Emitter<PlantIdentState> emit) async {
    //emit(PlantSecondIdentInitial());
    emit(PlantIdentLoadInProgress());
    try {
      //await locator<PlantService>().requestIdentByBotanic(event.isCorrect, event.requestId);
      await locator<PlantService>().sendUserIncorrectDecision(event.requestId);
      //emit(PlantSecondIdentSend());
    } on Exception catch (_, e) {
      emit(PlantIdentLoadFailure(errorMsg: e.toString()));
    }
  }
}
