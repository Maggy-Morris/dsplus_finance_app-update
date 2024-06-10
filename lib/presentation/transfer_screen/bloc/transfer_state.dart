// ignore_for_file: must_be_immutable

part of 'transfer_bloc.dart';

class TransferState extends Equatable {
  TransferState({
    this.transaction, // Initialize transaction property
    this.startDate,
    this.expectedDate,
    this.amountController,
    this.nameController,
    this.startDateController,
    this.extractedtDateController,
    this.transferModelObj,
    this.addedTransaction,
    this.error,
    this.accountNumberController,
    this.bankNameController,
    required this.files,
  });

  List<PlatformFile> files = const [];
  TransactionsModel? transaction; // Include transaction in copyWith
  final DateTime? startDate;
  final DateTime? expectedDate;
  final TransactionsModel? addedTransaction;
  final String? error;
  TransferModel? transferModelObj;
  TextEditingController? amountController;
  TextEditingController? nameController;
  TextEditingController? startDateController;
  TextEditingController? extractedtDateController;
  TextEditingController? accountNumberController;
  TextEditingController? bankNameController;

  @override
  List<Object?> get props => [
        startDate,
        expectedDate,
        transaction,
        files,
        addedTransaction,
        error,
        amountController,
        nameController,
        startDateController,
        extractedtDateController,
        transferModelObj,
        accountNumberController,
        bankNameController,
      ];
  TransferState copyWith(
      {TransactionsModel? transaction,
      TransactionsModel? addedTransaction,
      String? error,
      DateTime? startDate,
      DateTime? expectedDate,
      List<PlatformFile>? files, // Add this parameter

      TextEditingController? accountNumberController,
      TextEditingController? bankNameController,
      TextEditingController? amountController,
      TextEditingController? nameController,
      TextEditingController? startDateController,
      TextEditingController? extractedtDateController,
      TransferModel? transferModelObj}) {
    return TransferState(
      startDate: startDate ?? this.startDate,
      expectedDate: expectedDate ?? this.expectedDate,
      transaction: transaction ?? this.transaction,
      files: files ?? this.files,
      accountNumberController:
          accountNumberController ?? this.accountNumberController,
      bankNameController: bankNameController ?? this.bankNameController,
      addedTransaction: addedTransaction ?? this.addedTransaction,
      error: error ?? this.error,
      amountController: amountController ?? this.amountController,
      nameController: nameController ?? this.nameController,
      startDateController: startDateController ?? this.startDateController,
      extractedtDateController:
          extractedtDateController ?? this.extractedtDateController,
      transferModelObj: transferModelObj ?? this.transferModelObj,
    );
  }
}
