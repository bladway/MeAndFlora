import 'package:equatable/equatable.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object> get props => [];
}

class StatisticIdentRequested extends StatisticEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const StatisticIdentRequested({
    required this.startDate,
    required this.endDate,
  });
}

class StatisticAdWatchRequested extends StatisticEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const StatisticAdWatchRequested({
    required this.startDate,
    required this.endDate,
  });
}
