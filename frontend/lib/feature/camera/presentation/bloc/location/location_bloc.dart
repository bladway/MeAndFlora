import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationEvent>(
      (event, emit) async {
        if (event is LocationRequested) {
          await _getCurrentPosition(event, emit);
        }
      },
    );
  }

  _getCurrentPosition(
      LocationRequested event, Emitter<LocationState> emit) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(const LocationLoadFailure(
          errorMsg: 'Location services are disabled.'));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(const LocationLoadFailure(
            errorMsg: 'Location permissions are denied'));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(const LocationLoadFailure(
          errorMsg: 'Location permissions are permanently denied, '
              'we cannot request permissions.'));
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    emit(LocationLoadSuccess(
        lat: double.parse(position.latitude.toStringAsFixed(6)),
        lon: double.parse(position.longitude.toStringAsFixed(6))));
  }
}
