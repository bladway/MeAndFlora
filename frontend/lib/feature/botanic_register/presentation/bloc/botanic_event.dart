import 'package:equatable/equatable.dart';

abstract class BotanicEvent extends Equatable {
  const BotanicEvent();

  @override
  List<Object> get props => [];
}

class BotanicRegisterRequested extends BotanicEvent {
  final String login;
  final String password;

  const BotanicRegisterRequested({required this.login, required this.password});

  @override
  List<Object> get props => [];
}
