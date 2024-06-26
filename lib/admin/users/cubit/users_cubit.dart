import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState());

  void LoadAdmins() async{
    emit(state.copyWith(status: UsersStatus.loading));

    try {
    final snapshot=await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Admin')
          .get();
    final admins = snapshot.docs.map((doc) =>UserModel.fromJson(doc.data())).toList();
    emit(state.copyWith(admins: admins, status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void LoadUsers() async{
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'User')
          .get();
      final users = snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      emit(state.copyWith(users: users, status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void LoadSuperAdmins() async{
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'SuperAdmin')
          .get();
      final superAdmin = snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      emit(state.copyWith(superAdmins: superAdmin, status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void deleteUser(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).delete();
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void makeAdmin(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'Admin',
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void demoteAdmin(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'User',
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void makeSuperAdmin(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'SuperAdmin',
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void demoteSuperAdmin(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'User',
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void blockUser(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': 'Blocked',
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void unblockUser(String userId) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': 'Active',
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void updateUser(
      String userId, String name, String email, String role, String status) {
    emit(state.copyWith(status: UsersStatus.loading));

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        'role': role,
        'status': status,
      });
      emit(state.copyWith(status: UsersStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }
  currentUserRole() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((doc) {
      String role = doc.data()?['role'];
      print(role);
      emit(state.copyWith(currentUserRole: role));
    });
  }
}
