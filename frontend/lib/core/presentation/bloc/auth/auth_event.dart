import 'package:equatable/equatable.dart';

import '../../../domain/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UnauthRequested extends AuthEvent {

  const UnauthRequested();
}

class CheckIsLogInRequested extends AuthEvent {

  const CheckIsLogInRequested();
}

class SignInRequested extends AuthEvent {
  final String login;
  final String password;

  const SignInRequested(this.login, this.password);
}

class SignUpRequested extends AuthEvent {
  final String login;
  final String password;

  const SignUpRequested(this.login, this.password);
}

class LogOutRequested extends AuthEvent {}

class UpdateRequest extends AuthEvent {
  final Account account;

  const UpdateRequest({required this.account});
}
