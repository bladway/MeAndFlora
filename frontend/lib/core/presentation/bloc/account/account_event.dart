import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class ChangeInitialRequested extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class ChangeRequested extends AccountEvent {
  final String prevLogin;
  final String login;
  final String password;
  final String passwordConfirm;

  const ChangeRequested(
      {required this.prevLogin,
      required this.login,
      required this.password,
      required this.passwordConfirm});

  @override
  List<Object?> get props => [];
}

class AccountAddRequested extends AccountEvent {
  final Account account;

  const AccountAddRequested({required this.account});

  @override
  List<Object?> get props => [account];
}

class AccountRemoveRequested extends AccountEvent {
  final String login;

  const AccountRemoveRequested({required this.login});

  @override
  List<Object?> get props => [login];
}
