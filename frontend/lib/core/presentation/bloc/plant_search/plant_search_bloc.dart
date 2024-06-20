import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/plant_service.dart';
import 'plant_search.dart';

class PlantSearchBloc extends Bloc<PlantSearchEvent, PlantSearchState> {
  PlantSearchBloc() : super(PlantSearchInitial()) {
    on<PlantSearchEvent>(
      (event, emit) async {
        if (event is PlantSearchRequested) {
          await _requestPlantSearch(event, emit);
        }
      },
    );
  }

  Future<void> _requestPlantSearch(
      PlantSearchRequested event, Emitter<PlantSearchState> emit) async {
    if (event.plantName != "") {
      emit(PlantSearchLoadInProgress());
      try {
        // final Plant plant = await PlantService().findPlantByName(
        //     event.plantName);

        final Plant plant =
            await locator<PlantService>().findPlantByName(event.plantName);
        emit(PlantSearchLoadSuccess(plant: plant));
      } on Exception catch (_, e) {
        emit(PlantSearchLoadFailure(errorMsg: e.toString()));
      }
    }
  }
}
