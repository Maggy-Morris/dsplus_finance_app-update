// ignore_for_file: must_be_immutable

part of 'transfer_bloc.dart';

@immutable

// abstract class TransferEvent extends Equatable {}

class TransferEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTransactionEvent extends TransferEvent {
  final TransactionsModel transaction;

  AddTransactionEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class EditName extends TransferEvent {
  final String name;

  EditName({required this.name});

  @override
  List<Object?> get props => [name];
}

class EditAmount extends TransferEvent {
  final double amount;

  EditAmount({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class BankName extends TransferEvent {
  final String bankName;

  BankName({required this.bankName});

  @override
  List<Object?> get props => [bankName];
}

class AccountNumber extends TransferEvent {
  final int accountNumber;

  AccountNumber({required this.accountNumber});

  @override
  List<Object?> get props => [accountNumber];
}

class EditStartDate extends TransferEvent {
  final DateTime startDate;

  EditStartDate({required this.startDate});

  @override
  List<Object?> get props => [startDate];
}

class ExpectedDate extends TransferEvent {
  final DateTime expectedDate;

  ExpectedDate({required this.expectedDate});

  @override
  List<Object?> get props => [expectedDate];
}

class EditStartDateString extends TransferEvent {
  final String startDateString;

  EditStartDateString({required this.startDateString});

  @override
  List<Object?> get props => [startDateString];
}

class ExpectedDateString extends TransferEvent {
  final String expectedDateString;

  ExpectedDateString({required this.expectedDateString});

  @override
  List<Object?> get props => [expectedDateString];
}

class AddFilesEvent extends TransferEvent {
  final List<PlatformFile> files;
  AddFilesEvent(this.files);
}

class RemoveFile extends TransferEvent {
  final int index;

  RemoveFile(this.index);
}

class RadioButtonChanged extends TransferEvent {
  final String selectedOption;
  final bool showTextField;

  RadioButtonChanged(
      {required this.selectedOption, required this.showTextField});
}


// class UpdateTransactionEvent extends TransferEvent {
//   final TransactionsModel updatedTransaction;

//   UpdateTransactionEvent(this.updatedTransaction);
// }





