import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/domain/models/account.dart';
import 'package:me_and_flora/core/domain/service/account_service.dart';

import 'account_list.dart';

class AccountListBloc extends Bloc<AccountListEvent, AccountListState> {
  AccountListBloc() : super(AccountListInitial()) {
    on<AccountListEvent>(
      (event, emit) async {
        if (event is AccountListRequested) {
          await _getAccounts(event, emit);
        }
      },
    );
  }

  _getAccounts(
      AccountListRequested event, Emitter<AccountListState> emit) async {
    emit(AccountListLoadInProcess());
    try {
      final List<Account> accounts = await AccountService().getAccountList();
      emit(AccountListLoadSuccess(accounts: accounts));
    } catch (e) {
      emit(AccountListLoadFailure(errorMsg: e.toString()));
    }
  }
}
