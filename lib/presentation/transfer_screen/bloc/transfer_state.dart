// ignore_for_file: must_be_immutable

part of 'transfer_bloc.dart';

class TransferState extends Equatable {
  TransferState({
    this.amount = 0,
    this.name = "",
    this.userName = "",
    this.accountNumber = 0,
    this.bankName = "",
    this.selectedOption = '',
    this.showTextField = false,
    this.transaction, // Initialize transaction property
    this.startDate,
    this.startDateString,
    this.expectedDateString,
    this.expectedDate,
    // this.amountController,
    // this.nameController,
    // this.startDateController,
    // this.extractedtDateController,
    this.transferModelObj,
    this.addedTransaction,
    this.error,
    // this.accountNumberController,
    // this.bankNameController,
    this.files = const [],
  });

  final String userName;
  final List<PlatformFile> files;
  TransactionsModel? transaction; // Include transaction in copyWith
  final DateTime? startDate;
  final DateTime? expectedDate;
  final TransactionsModel? addedTransaction;
  final String? error;
  final String? name;
  final double? amount;
  final String? bankName;
  final int? accountNumber;

  final String? expectedDateString;
  final String? startDateString;

  final String? selectedOption;
  final bool? showTextField;
  TransferModel? transferModelObj;
  // TextEditingController? amountController;
  // TextEditingController? nameController;
  // TextEditingController? startDateController;
  // TextEditingController? extractedtDateController;
  // TextEditingController? accountNumberController;
  // TextEditingController? bankNameController;

  @override
  List<Object?> get props => [
        userName,
        accountNumber,
        bankName,
        startDateString,
        expectedDateString,
        amount,
        name,
        showTextField,
        selectedOption,
        startDate,
        expectedDate,
        transaction,
        files,
        addedTransaction,
        error,
        // amountController,
        // nameController,
        // startDateController,
        // extractedtDateController,
        transferModelObj,
        // accountNumberController,
        // bankNameController,
      ];
  TransferState copyWith(
      {String? bankName,
      String? userName,
      int? accountNumber,
      String? startDateString,
      String? expectedDateString,
      String? name,
      double? amount,
      TransactionsModel? transaction,
      TransactionsModel? addedTransaction,
      String? error,
      DateTime? startDate,
      DateTime? expectedDate,
      List<PlatformFile>? files, // Add this parameter
      bool? showTextField,
      String? selectedOption,
      // TextEditingController? accountNumberController,
      // TextEditingController? bankNameController,
      // TextEditingController? amountController,
      // TextEditingController? nameController,
      // TextEditingController? startDateController,
      // TextEditingController? extractedtDateController,
      TransferModel? transferModelObj}) {
    return TransferState(
      userName: userName ?? this.userName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      startDateString: startDateString ?? this.startDateString,
      expectedDateString: expectedDateString ?? this.expectedDateString,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      selectedOption: selectedOption ?? this.selectedOption,
      showTextField: showTextField ?? this.showTextField,
      startDate: startDate ?? this.startDate,
      expectedDate: expectedDate ?? this.expectedDate,
      transaction: transaction ?? this.transaction,
      files: files ?? this.files,
      // accountNumberController:
      //     accountNumberController ?? this.accountNumberController,
      // bankNameController: bankNameController ?? this.bankNameController,
      addedTransaction: addedTransaction ?? this.addedTransaction,
      error: error ?? this.error,
      // amountController: amountController ?? this.amountController,
      // nameController: nameController ?? this.nameController,
      // startDateController: startDateController ?? this.startDateController,
      // extractedtDateController:
      //     extractedtDateController ?? this.extractedtDateController,
      transferModelObj: transferModelObj ?? this.transferModelObj,
    );
  }
}
