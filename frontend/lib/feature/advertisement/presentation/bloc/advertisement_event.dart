import 'package:equatable/equatable.dart';

abstract class AdvertisementEvent extends Equatable {
  const AdvertisementEvent();

  @override
  List<Object> get props => [];
}

class AdvertisementInitialized extends AdvertisementEvent {}
