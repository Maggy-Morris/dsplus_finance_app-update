// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    // this.homeModelObj,
    this.allTransactions = const [],
  });

  // HomeModel? homeModelObj;
  final List<TransactionsModel> allTransactions;

  @override
  List<Object?> get props => [
        // homeModelObj,
        allTransactions,
      ];

  HomeState copyWith({
    // HomeModel? homeModelObj,
    List<TransactionsModel>? allTransactions,
  }) {
    return HomeState(
      // homeModelObj: homeModelObj ?? this.homeModelObj,
      allTransactions: allTransactions ?? this.allTransactions,
    );
  }
}
