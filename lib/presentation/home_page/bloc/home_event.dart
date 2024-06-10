// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AllTransactionsEvent extends HomeEvent {
  final List<TransactionsModel> allTransactions;

  AllTransactionsEvent({required this.allTransactions});

  @override
  List<Object?> get props => [allTransactions,];
}
