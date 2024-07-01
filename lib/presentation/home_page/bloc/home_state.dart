// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    // this.homeModelObj,
    this.userModel,
    this.allTransactions = const [],
    this.loading = false,
  });

  // HomeModel? homeModelObj;
  final List<TransactionsModel> allTransactions;
  final UserModel? userModel;
  final bool loading;

  @override
  List<Object?> get props => [
        // homeModelObj,
        allTransactions,
        userModel,
        loading,
      ];

  HomeState copyWith({
    // HomeModel? homeModelObj,
    List<TransactionsModel>? allTransactions,
    UserModel? userModel,
    bool? loading,
  }) {
    return HomeState(
      // homeModelObj: homeModelObj ?? this.homeModelObj,
      allTransactions: allTransactions ?? this.allTransactions,
      userModel: userModel ?? this.userModel,
      loading: loading ?? this.loading,
    );
  }
}
