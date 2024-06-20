import 'package:equatable/equatable.dart';

abstract class BotanicState extends Equatable {
  const BotanicState();

  @override
  List<Object> get props => [];
}

class BotanicInitial extends BotanicState {}

class BotanicLoadInProcess extends BotanicState {}

class BotanicLoadSuccess extends BotanicState {}

class BotanicLoadFailure extends BotanicState {
  final String errorMsg;

  const BotanicLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
