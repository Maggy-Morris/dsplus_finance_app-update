part of 'settlements_of_accounts_bloc.dart';

class SettlementsOfAccountsState extends Equatable {
  SettlementsOfAccountsState(
      {this.descriptionController = "",
      this.amountController = 0,
      this.settlementsOfAccountsModelObj});

  SettlementsOfAccountsModel? settlementsOfAccountsModelObj;
  final String descriptionController;
  final double amountController;

  @override
  List<Object?> get props => [
        descriptionController,
        amountController,
        settlementsOfAccountsModelObj,
      ];

  SettlementsOfAccountsState copyWith(
      {double? amountController,
      String? descriptionController,
      SettlementsOfAccountsModel? settlementsOfAccountsModelObj}) {
    return SettlementsOfAccountsState(
      amountController: amountController ?? this.amountController,
      descriptionController:
          descriptionController ?? this.descriptionController,
      settlementsOfAccountsModelObj:
          settlementsOfAccountsModelObj ?? this.settlementsOfAccountsModelObj,
    );
  }
}
