import 'package:bloc/bloc.dart';
import 'package:me_and_flora/core/domain/models/account.dart';
import 'package:me_and_flora/core/exception/auth_exception.dart';

import '../../../domain/service/auth_service.dart';
import 'auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {

    on<UnauthRequested>((event, emit) async {
      //AuthService.logout();
      Account user = Account();
      emit(AuthSuccessState(account: user));
      emit(AuthenticatedState(account: user));
    });

    on<LogOutRequested>((event, emit) async {
      //AuthService.logout();
      emit(AuthInitialState());
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Account user = await AuthService().signIn(event.login, event.password);
        emit(AuthSuccessState(account: user));
        emit(AuthenticatedState(account: user));
      } on UserNotFoundException catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Account user = await AuthService().signUp(event.login, event.password);
        /*
        Account user = Account(
          login: event.login,
          password: event.password,
          accessLevel: AccessLevel.user,
        );*/
        emit(AuthSuccessState(account: user));
        emit(AuthenticatedState(account: user));
      } catch (e) {
        emit(UnauthenticatedState());
      }
    });

    on<UpdateRequest>((event, emit) async {
      emit(AuthenticatedState(account: event.account));
    });
  }
}
