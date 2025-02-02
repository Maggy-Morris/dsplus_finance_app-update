import 'dart:io';

import 'package:dsplus_finance/data/apiClient/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/app/app_export.dart';
import 'package:dsplus_finance/presentation/transfer_screen/models/transfer_model.dart';

import '../../../core/di/injector.dart';
import '../../home_page/models/transactions_model.dart';
part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  ApiClient _apiClient = getIt<ApiClient>();

  TransferBloc(TransferState initialState) : super(initialState) {
    on<TransferEvent>(_onInitialize);
    on<AddTransactionEvent>(_onAddTransactionEvent);
    on<AddFilesEvent>(_onAddFilesEvent);
  }

  _onInitialize(
    TransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(
      accountNumberController: TextEditingController(),
      bankNameController: TextEditingController(),
      nameController: TextEditingController(),
      amountController: TextEditingController(),
      startDateController: TextEditingController(),
      extractedtDateController: TextEditingController(),
      files: [], // Initialize files
    ));
  }

//   Future<TransactionsModel> add(AddTransactionEvent event) async {
//   final ref = firestore
//       .collection('users')
//       .doc(firebaseAuth.currentUser!.uid)
//       .collection('transactions')
//       .doc();

//   await ref.set(event.transaction.toJson());

//   return event.transaction.copyWith(id: ref.id);
// }

  _onAddFilesEvent(
    AddFilesEvent event,
    Emitter<TransferState> emit,
  ) {
    emit(state.copyWith(
        files: event.files)); // Update files with the selected files
  }

  _onAddTransactionEvent(
    AddTransactionEvent event,
    Emitter<TransferState> emit,
  ) async {
    // mapEventToState(event);
    try {
      await _apiClient.addTransactions(event.transaction);
      emit(state.copyWith(addedTransaction: event.transaction));
    } catch (error) {
      emit(state.copyWith(
          addedTransaction: TransactionsModel(), error: error.toString()));
    }
  }
  

  // void pickAndAddFiles(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       allowMultiple: true,
  //     );

  //     if (result != null) {
  //       List<PlatformFile> pickedFiles = result.files;
  //       add(AddFilesEvent(pickedFiles));
  //     }
  //   } catch (error) {
  //     // Handle error
  //   }
  // }




  void captureAndAddImage(BuildContext context) async {
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

      add(AddFilesEvent([pickedFile]));
    }
  } catch (error) {
    // Handle error
    print("Error picking image from camera: $error");
  }
}

  void pickAndAddFiles(BuildContext context) async {
    try {
      List<XFile>? result = await ImagePicker().pickMultiImage();

      if (result != null) {
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
        add(AddFilesEvent(pickedFiles));
      }
    } catch (error) {}
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
      for (final file in state.files) {
        String filePath = 'attachments/${file.name}';

        Reference ref = FirebaseStorage.instance.ref().child(filePath);
        TaskSnapshot uploadTask = await ref.putData(file.bytes!);
        // Get the download URL of the uploaded file
        String fileUrl = await uploadTask.ref.getDownloadURL();
        fileUrls.add(fileUrl);
      }

      // Update the transaction model with the file URLs
      // TransactionsModel transaction = state.transaction ?? TransactionsModel();
      transaction.attachments = fileUrls;

      // .copyWith(attachments: fileUrls, cashOrCredit: false);

      add(AddTransactionEvent(transaction));
    } catch (error) {
      print("Error uploading files: $error");
    }
  }

  Stream<TransferState> mapEventToState(AddTransactionEvent event) async* {
    // Add your logic here to add the transaction and upload it to Firebase
    try {
      // Add the transaction to your database
      // Example:
      await _apiClient.addTransactions(event.transaction);
      // await myFirebaseService.addTransaction(event.transaction);
      yield state.copyWith(addedTransaction: event.transaction);
    } catch (error) {
      yield state.copyWith(error: error.toString());
    }
  }
}
