import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/service/account_service.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/feature/advertisement/presentation/bloc/advertisement_event.dart';
import 'package:me_and_flora/feature/advertisement/presentation/bloc/advertisement_state.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  AdvertisementBloc() : super(AdvertisementInitial()) {
    on<AdvertisementEvent>((event, emit) async {
      if (event is AdvertisementInitialized) {
        await seeAdvertisement(event, emit);
      }
    },
    );
  }

  seeAdvertisement(
      AdvertisementInitialized event, Emitter<AdvertisementState> emit) async {
    emit(AdvertisementInitial());
    try {
      await locator<AccountService>().seeAdvertisement();
      emit(AdvertisementSuccess());
    } catch (e) {
      emit(AdvertisementFailed());
    }
  }
}
