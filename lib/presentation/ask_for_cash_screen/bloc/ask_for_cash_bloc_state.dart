part of 'ask_for_cash_bloc_bloc.dart';

// ignore: must_be_immutable
class AskForCashBlocState extends Equatable {
  AskForCashBlocState(
      {this.amountController, this.nameController, this.AskForCashModelObj});



  TextEditingController? amountController;
  TextEditingController? nameController;

  AskForCashModel? AskForCashModelObj;
  @override
  List<Object?> get props => [
        AskForCashModelObj,
        nameController,
        amountController,
      ];

  AskForCashBlocState copyWith({
    TextEditingController? amountController,
    TextEditingController? nameController,
    AskForCashModel? AskForCashModelObj,
  }) {
    return AskForCashBlocState(
      amountController: amountController ?? this.amountController,
      nameController: nameController ?? this.nameController,
      AskForCashModelObj: AskForCashModelObj ?? this.AskForCashModelObj,
    );
  }
}
