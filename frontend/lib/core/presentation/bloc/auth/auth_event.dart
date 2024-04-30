import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class UnauthRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String login;
  final String password;

  const SignInRequested(this.login, this.password);

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String login;
  final String password;

  const SignUpRequested(this.login, this.password);

  @override
  List<Object?> get props => [login, password];
}

class LogOutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class UpdateRequest extends AuthEvent {
  final Account account;

  const UpdateRequest({required this.account});

  @override
  List<Object?> get props => [account];
}
