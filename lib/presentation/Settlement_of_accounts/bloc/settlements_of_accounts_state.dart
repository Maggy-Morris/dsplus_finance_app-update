part of 'settlements_of_accounts_bloc.dart';


class SettlementsOfAccountsState extends Equatable {
  SettlementsOfAccountsState({

    
    this.descriptionController,
    this.amountController,

    this.settlementsOfAccountsModelObj});

  SettlementsOfAccountsModel? settlementsOfAccountsModelObj;
    TextEditingController? descriptionController;
    TextEditingController? amountController;

  @override
  List<Object?> get props => [
       descriptionController,
amountController,
        settlementsOfAccountsModelObj,
      ];


      
  SettlementsOfAccountsState copyWith({
        TextEditingController? amountController,

    TextEditingController? descriptionController,
    SettlementsOfAccountsModel? settlementsOfAccountsModelObj}) {
    return SettlementsOfAccountsState(
      amountController:amountController ?? this.amountController,
     descriptionController:descriptionController ?? this.descriptionController,
      settlementsOfAccountsModelObj: settlementsOfAccountsModelObj ?? this.settlementsOfAccountsModelObj,
    );
  }



}

