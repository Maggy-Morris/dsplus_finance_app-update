import 'dart:typed_data'; // for Uint8List
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  XFile? pickedFile;
  Uint8List? bytes;

  AddUserCubit() : super(AddUserState());

  Future<void> addUser(String name, String email, String password, String role,
      String jobTitle) async {
    emit(state.copyWith(status: AddUserStatus.loading));

    try {
      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
      UserCredential userCredential;


        userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(email: email, password: password);

      if (state.images != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(pickedFile!.path);

        final UploadTask uploadTask = storageRef.putData(bytes!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {
          print('Image uploaded successfully.');
        });

        final String imageUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instanceFor(app: app)
            .collection('users')
            .doc(
          userCredential.user!.uid,
            )
            .set({
          'name': name,
          'email': email,
          'role': role,
          'password': password,
          'jobTitle': jobTitle,
          'userImageUrl': imageUrl,
          "uid": userCredential.user!.uid,
        });

        emit(state.copyWith(status: AddUserStatus.success));
      } else {
        emit(state.copyWith(status: AddUserStatus.error));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'The user corresponding to the given email has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'There is no user corresponding to the given email.';
          break;
        case 'wrong-password':
          errorMessage = 'The password is invalid for the given email.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use by another account.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email and password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        default:
          errorMessage = 'An undefined Error happened.';
      }

      emit(state.copyWith(status: AddUserStatus.error, error: errorMessage));
    } catch (e) {
      emit(state.copyWith(status: AddUserStatus.error, error: e.toString()));
    }
  }

  void uploadImage() async {
    try {
      final picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        bytes = await pickedFile!.readAsBytes();
        emit(state.copyWith(images: bytes, status: AddUserStatus.editing));
      }
    } catch (err) {
      print(err);
    }
  }
}
