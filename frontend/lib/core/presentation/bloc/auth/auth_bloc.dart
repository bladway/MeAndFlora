import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/models/account.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/exception/auth_exception.dart';

import '../../../domain/service/auth_service.dart';
import 'auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {

    on<CheckIsLogInRequested>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Account account = await locator<AuthService>().loadUser();
        emit(AuthSuccessState(account: account));
        emit(AuthenticatedState(account: account));
      } on UserNotFoundException catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<UnauthRequested>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Account account = await locator<AuthService>().signInAnonymous();
        emit(AuthSuccessState(account: account));
        emit(AuthenticatedState(account: account));
      } on Exception catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LogOutRequested>((event, emit) async {
      await locator<AuthService>().logout();
      emit(AuthInitialState());
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Account account = await locator<AuthService>().signIn(event.login, event.password);
        emit(AuthSuccessState(account: account));
        emit(AuthenticatedState(account: account));
      } on Exception catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Account account = await locator<AuthService>().signUp(event.login, event.password);
        emit(AuthSuccessState(account: account));
        emit(AuthenticatedState(account: account));
      } catch (e) {
        emit(UnauthenticatedState());
      }
    });

    on<UpdateRequest>((event, emit) async {
      emit(AuthenticatedState(account: event.account));
    });
  }
}
