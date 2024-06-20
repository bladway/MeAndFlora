import 'package:bloc/bloc.dart';
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
    emit(UnkonwPlantsLoadInProgress());
    try {
      final List<Plant> plantList = await PlantService().getUnknownPlants();
      emit(UnknownPlantListSuccess(plants: plantList));
    } catch (e) {
      emit(UnknownPlantListFailture());
    }
  }
}
