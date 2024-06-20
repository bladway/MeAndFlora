import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/exception/account_exception.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';

import '../../../domain/models/models.dart';
import '../../../domain/service/account_service.dart';
import '../../../domain/service/auth_service.dart';
import 'account.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(ChangeInitialState()) {
    on<ChangeRequested>((event, emit) async {
      await _changeAccount(event, emit);
    });

    on<AccountAddRequested>((event, emit) async {
      await _addAccount(event, emit);
    });

    on<AccountRemoveRequested>((event, emit) async {
      await _removeAccount(event, emit);
    });
  }

  _changeAccount(ChangeRequested event, Emitter<AccountState> emit) async {
    emit(ChangeLoadingState());
    try {
      Account account = await locator<AuthService>().editAccount(
          event.prevLogin, event.login, event.password, event.passwordConfirm);
      //Account account = await AuthService().editAccount(event.prevLogin, event.login, event.password, event.passwordConfirm);
      emit(ChangeSavedState(account: account));
    } on AccountEditException catch (_) {
      emit(ChangeErrorState());
    }
  }

  _addAccount(AccountAddRequested event, Emitter<AccountState> emit) async {
    emit(AccountLoadInProcess());
    try {
      await locator<AccountService>().addAccount(event.account);
      emit(AccountAddSuccess());
    } catch (e) {
      emit(ChangeErrorState());
    }
  }

  _removeAccount(
      AccountRemoveRequested event, Emitter<AccountState> emit) async {
    emit(AccountLoadInProcess());
    try {
      await locator<AccountService>().removeAccount(event.login);
      emit(AccountRemoveSuccess());
    } catch (e) {
      emit(ChangeErrorState());
    }
  }
}
