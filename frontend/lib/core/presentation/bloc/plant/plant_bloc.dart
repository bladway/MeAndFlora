import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/models.dart';
import 'plant_event.dart';
import 'plant_state.dart';

class PlantBloc extends Bloc<PlantEvent, PlantState> {

  PlantBloc() : super(PlantInitial()) {
    on<PlantEvent>((event, emit) async {
      if (event is PlantHomePageRequested) {
        await _requestPlantList(event, emit);
      }
    },
    );
  }

  Future<void> _requestPlantList(PlantHomePageRequested event,
      Emitter<PlantState> emit) async {
    emit(PlantLoadInProgress());
    final List<Plant> plantList = [
      const Plant(name: "Plant1", type: "Дерево",
          description: "fvjnsjnsdjfnsjkfnsjdbkjbilnbknlknjlkmlmjljmlknjknjkbjkbhnv kbjlkjbnlknklnjcnsdjcnscjsdc",
          isLiked: true, imageUrl: "something"),
      const Plant(name: "Plant2", type: "Дерево",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: false, imageUrl: "something"),
      const Plant(name: "Plant3", type: "Мох",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: false, imageUrl: "something"),
      const Plant(name: "Plant4", type: "Мох",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: false, imageUrl: "something"),
      const Plant(name: "Plant5", type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: true, imageUrl: "something"),
      const Plant(name: "Plant6", type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: false, imageUrl: "something"),
      const Plant(name: "Plant7", type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: true, imageUrl: "something"),
      const Plant(name: "Plant8", type: "Мох",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc",
          isLiked: true, imageUrl: "something"),
      const Plant(name: "Plant9", type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc", isLiked: false,
          imageUrl: "something"),
      const Plant(name: "Plant10", type: "Цветок",
          description: "fvjnsjnsdjfnsjkfnsjdcnsdjcnscjsdc", isLiked: true,
          imageUrl: "something"),
    ]; //await PlantService.getPlantList();
    emit(PlantLoadSuccess(plantList: plantList));
  }
}