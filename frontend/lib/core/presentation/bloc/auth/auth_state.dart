import 'package:equatable/equatable.dart';
import 'package:me_and_flora/core/domain/models/account.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class UnauthenticatedState extends AuthState {}

class AuthSuccessState extends AuthState {
  final Account account;

  const AuthSuccessState({required this.account});

  @override
  List<Object> get props => [account];
}

class AuthenticatedState extends AuthState {
  final Account account;

  const AuthenticatedState({required this.account});

  @override
  List<Object> get props => [account];
}

class AuthErrorState extends AuthState {
  final String error;
  const AuthErrorState(this.error);

  @override
  List<Object> get props => [error];
}