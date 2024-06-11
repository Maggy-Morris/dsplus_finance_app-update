// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AddUserStatus { initial, loading, success, error }

class AddUserCubit extends Cubit<AddUserStatus> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _fireStore;

  AddUserCubit(this._auth, this._fireStore) : super(AddUserStatus.initial);

  void addUser(String name, String email, String password, String role , String userName) async {
    emit(AddUserStatus.loading);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        "password": password,
        "uid": userCredential.user!.uid,
        "username": userName,
      });

      emit(AddUserStatus.success);
    } catch (e) {
      emit(AddUserStatus.error);
    }
  }
}


