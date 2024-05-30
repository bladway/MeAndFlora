import 'package:equatable/equatable.dart';
import 'package:me_and_flora/core/domain/models/models.dart';

abstract class AccountListEvent extends Equatable {
  const AccountListEvent();

  @override
  List<Object> get props => [];
}

class AccountListRequested extends AccountListEvent {
  final int page;
  final int? size;

  const AccountListRequested({this.page = 0, this.size});
}
