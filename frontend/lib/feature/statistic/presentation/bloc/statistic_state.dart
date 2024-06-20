import 'package:equatable/equatable.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}

class StatisticLoadInProgress extends StatisticState {}

class StatisticIdentLoadSuccess extends StatisticState {
  final Map map;

  const StatisticIdentLoadSuccess({required this.map});
}

class StatisticAdWatchLoadSuccess extends StatisticState {
  final Map map;

  const StatisticAdWatchLoadSuccess({required this.map});
}

class StatisticLoadFailture extends StatisticState {}