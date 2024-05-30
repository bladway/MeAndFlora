import 'package:equatable/equatable.dart';

abstract class AdvertisementState extends Equatable {
  const AdvertisementState();

  @override
  List<Object> get props => [];
}

class AdvertisementInitial extends AdvertisementState {}

class AdvertisementSuccess extends AdvertisementState {}

class AdvertisementFailed extends AdvertisementState {}