import 'dart:io';

import 'package:dsplus_finance/data/apiClient/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app/app_export.dart';
import 'package:dsplus_finance/presentation/transfer_screen/models/transfer_model.dart';

import '../../../core/di/injector.dart';
import '../../home_page/models/transactions_model.dart';
part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  static TransferBloc get(context) => BlocProvider.of<TransferBloc>(context);

  ApiClient _apiClient = getIt<ApiClient>();

  TransferBloc() : super(TransferState(files: [])) {
    on<TransferEvent>(_onInitialize);
    on<AddTransactionEvent>(_onAddTransactionEvent);
    on<AddFilesEvent>(_onAddFilesEvent);
    on<EditName>(_onEditName);
    on<EditUserName>(_onEditUserName);

    on<EditAmount>(_onEditAmount);

    on<EditStartDate>(_onEditStartDate);
    on<EditStartDateString>(_onEditStartDateString);

    on<ExpectedDate>(_onExpectedDate);
    on<ExpectedDateString>(_onExpectedDateString);
    on<AccountNumber>(_onAccountNumber);
    on<BankName>(_onBankName);

    on<RadioButtonChanged>(_onRadioButtonChanged);
  }

  _onInitialize(
    TransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(
      files: [], // Initialize files
    ));
  }

  _onAddFilesEvent(AddFilesEvent event, Emitter<TransferState> emit) {
    List<PlatformFile> newFiles = List.from(state.files);

    if (event.files != null && event.files.isNotEmpty) {
      newFiles.addAll(event.files);

      emit(state.copyWith(
        files: newFiles,
      ));
    } else if (event.index != null) {
      newFiles.removeAt(event.index ?? 0);
      emit(state.copyWith(
        files: newFiles,
      ));
    }
  }

  _onAddTransactionEvent(
    AddTransactionEvent event,
    Emitter<TransferState> emit,
  ) async {
    try {
      await _apiClient.addTransactions(event.transaction);
      emit(state.copyWith(addedTransaction: event.transaction));
    } catch (error) {
      emit(state.copyWith(
          addedTransaction: TransactionsModel(), error: error.toString()));
    }
  }

  _onEditUserName(
    EditUserName event,
    Emitter<TransferState> emit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString('userName') ?? "";

    try {
      emit(state.copyWith(userName: userName));
    } catch (error) {
      // emit(state.copyWith(
      //     addedTransaction: TransactionsModel(), error: error.toString()));
    }
  }

  _onRadioButtonChanged(
      RadioButtonChanged event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        selectedOption: event.selectedOption,
        showTextField: event.showTextField,
      ),
    );
  }

  _onEditName(EditName event, Emitter<TransferState> emit) async {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  _onEditAmount(EditAmount event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        amount: event.amount,
      ),
    );
  }

  _onEditStartDate(EditStartDate event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        startDate: event.startDate,
      ),
    );
  }

  _onExpectedDate(ExpectedDate event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        expectedDate: event.expectedDate,
      ),
    );
  }

  _onEditStartDateString(
      EditStartDateString event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        startDateString: event.startDateString,
      ),
    );
  }

  _onExpectedDateString(
      ExpectedDateString event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        expectedDateString: event.expectedDateString,
      ),
    );
  }

  _onBankName(BankName event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        bankName: event.bankName,
      ),
    );
  }

  _onAccountNumber(AccountNumber event, Emitter<TransferState> emit) async {
    emit(
      state.copyWith(
        accountNumber: event.accountNumber,
      ),
    );
  }

  void captureAndAddImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera, // Specify the image source as camera
      );

      if (image != null) {
        int size = await File(image.path).length();
        PlatformFile pickedFile = PlatformFile(
          name: image.name,
          path: image.path,
          size: size,
          bytes: await File(image.path).readAsBytes(),
        );

        List<PlatformFile> updatedFiles = List.from(state.files);
        updatedFiles.add(pickedFile);

        add(AddFilesEvent(files: updatedFiles));
      }
    } catch (error) {
      // Handle error
      debugPrint("Error picking image from camera: $error");
    }
  }

  void pickAndAddFiles() async {
    try {
      List<XFile>? result = await ImagePicker().pickMultiImage();

      if (result.isNotEmpty) {
        List<Future<PlatformFile>> pickedFilesFutures =
            result.map((file) async {
          int size = await File(file.path).length();
          return PlatformFile(
            name: file.name,
            path: file.path,
            size: size,
            bytes: await File(file.path).readAsBytes(),
          );
        }).toList();

        List<PlatformFile> pickedFiles = await Future.wait(pickedFilesFutures);

        List<PlatformFile> updatedFiles = List.from(state.files);
        updatedFiles.addAll(pickedFiles);

        add(AddFilesEvent(files: updatedFiles));
      }
    } catch (error) {
      // Handle error
      debugPrint("Error picking images: $error");
    }
  }

  void removeFileAtIndex(int index) {
    List<PlatformFile> updatedFiles = List.from(state.files);
    updatedFiles.removeAt(index);
    emit(state.copyWith(files: updatedFiles));
  }

  // upload files to firebase
  uploadFilesAndUpdateTransaction(TransactionsModel transaction) async {
    try {
      List<String> fileUrls = [];
      for (final file in transaction.attachments ?? []) {
        String filePath = 'attachments/${file.name}';

        Reference ref = FirebaseStorage.instance.ref().child(filePath);
        TaskSnapshot uploadTask = await ref.putData(file.bytes!);
        // Get the download URL of the uploaded file
        String fileUrl = await uploadTask.ref.getDownloadURL();
        fileUrls.add(fileUrl);
      }

      // Update the transaction model with the file URLs
      transaction.attachments = fileUrls;
      // debugPrint(fileUrls);

      add(AddTransactionEvent(transaction));
    } catch (error) {
      debugPrint("Error uploading files: $error");
    }
  }

  Stream<TransferState> mapEventToState(AddTransactionEvent event) async* {
    try {
      await _apiClient.addTransactions(event.transaction);
      yield state.copyWith(addedTransaction: event.transaction);
    } catch (error) {
      yield state.copyWith(error: error.toString());
    }
  }
}
