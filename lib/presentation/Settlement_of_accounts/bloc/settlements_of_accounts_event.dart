part of 'settlements_of_accounts_bloc.dart';

class SettlementsOfAccountsEvent extends Equatable {
  const SettlementsOfAccountsEvent();

  @override
  List<Object> get props => [];
}

class EditDescrition extends SettlementsOfAccountsEvent {
  final String description;
  const EditDescrition({required this.description});

  @override
  List<Object> get props => [description];
}

class EditAmount extends SettlementsOfAccountsEvent {
  final double amount;
  const EditAmount({required this.amount});

  @override
  List<Object> get props => [amount];
}
