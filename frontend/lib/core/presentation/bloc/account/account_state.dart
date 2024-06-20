import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class ChangeInitialState extends AccountState {}

class ChangeLoadingState extends AccountState {}

class ChangeSavedState extends AccountState {
  final Account account;

  const ChangeSavedState({required this.account});

  @override
  List<Object> get props => [account];
}

class AccountLoadInProcess extends AccountState {}

class AccountAddSuccess extends AccountState {}

class AccountRemoveSuccess extends AccountState {}

class ChangeErrorState extends AccountState {}