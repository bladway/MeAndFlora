import 'package:equatable/equatable.dart';

import '../../../../core/domain/models/models.dart';

abstract class AccountListState extends Equatable {
  const AccountListState();

  @override
  List<Object> get props => [];
}

class AccountListInitial extends AccountListState {}

class AccountListLoadInProcess extends AccountListState {}

class AccountListLoadSuccess extends AccountListState {
  final List<Account> accounts;
  final int page;

  const AccountListLoadSuccess({required this.page, required this.accounts});
}

class AccountListLoadFailure extends AccountListState {
  final String errorMsg;

  const AccountListLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}