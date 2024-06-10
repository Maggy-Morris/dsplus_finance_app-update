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

class AddFilesEvent extends TransferEvent {
  final List<PlatformFile > files;
  AddFilesEvent(this.files);
}

class RemoveFile extends TransferEvent {
  final int index;

  RemoveFile(this.index);
}

// class UpdateTransactionEvent extends TransferEvent {
//   final TransactionsModel updatedTransaction;

//   UpdateTransactionEvent(this.updatedTransaction);
// }





