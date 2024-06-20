import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/statistic_service.dart';

import 'statistic.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(StatisticInitial()) {
    on<StatisticEvent>(
      (event, emit) async {
        if (event is StatisticIdentRequested) {
          await _getIdentStatistic(event, emit);
        }
        if (event is StatisticAdWatchRequested) {
          await _getAdWatchStatistic(event, emit);
        }
      },
    );
  }

  _getIdentStatistic(
      StatisticIdentRequested event, Emitter<StatisticState> emit) async {
    emit(StatisticLoadInProgress());
    try {
      final Map map = await StatisticService()
          .getIdentStatistic(event.startDate, event.endDate);
      emit(StatisticIdentLoadSuccess(map: map));
    } catch (e) {
      emit(StatisticLoadFailture());
    }
  }

  _getAdWatchStatistic(
      StatisticAdWatchRequested event, Emitter<StatisticState> emit) async {
    emit(StatisticLoadInProgress());
    try {
      final Map map = await StatisticService()
          .getAdWatchStatistic(event.startDate, event.endDate);
      emit(StatisticAdWatchLoadSuccess(map: map));
    } catch (e) {
      emit(StatisticLoadFailture());
    }
  }
}
