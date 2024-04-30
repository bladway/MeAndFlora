import 'package:flutter_bloc/flutter_bloc.dart';

import 'botanic.dart';

class BotanicBloc extends Bloc<BotanicEvent, BotanicState> {
  BotanicBloc() : super(BotanicInitial()) {
    on<BotanicEvent>(
      (event, emit) async {
        if (event is BotanicRegisterRequested) {
          await _getAccounts(event, emit);
        }
      },
    );
  }

  _getAccounts(
      BotanicRegisterRequested event, Emitter<BotanicState> emit) async {
    emit(BotanicLoadInProcess());
    try {
      //await AccountService().addAccount(account: Account(login: event.login, password: event.password));
      emit(BotanicLoadSuccess());
    } catch (e) {
      emit(BotanicLoadFailure(errorMsg: e.toString()));
    }
  }
}
