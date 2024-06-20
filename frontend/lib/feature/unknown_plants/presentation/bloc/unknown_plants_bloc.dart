import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/feature/unknown_plants/presentation/bloc/unknown_plants.dart';

import '../../../../core/domain/models/models.dart';
import '../../../../core/domain/service/plant_service.dart';

class UnknownPlantsBloc extends Bloc<UnknownPlantsEvent, UnknownPlantsState> {
  UnknownPlantsBloc() : super(UnknownPlantsInitial()) {
    on<UnknownPlantsEvent>(
      (event, emit) async {
        if (event is UnknownPlantsRequested) {
          await _getUnknownPlants(event, emit);
        }
      },
    );
  }

  _getUnknownPlants(
      UnknownPlantsRequested event, Emitter<UnknownPlantsState> emit) async {
    emit(UnknownPlantsLoadInProgress());
    try {
      final Map<int, Plant> requestPlants = await locator<PlantService>()
          .getUnknownPlantsByBotanic(event.page, event.size);
      emit(UnknownPlantListSuccess(
          plantIdList: requestPlants.keys.toList(),
          plants: requestPlants.values.toList()));
    } catch (e) {
      emit(UnknownPlantListFailture());
    }
  }
}
