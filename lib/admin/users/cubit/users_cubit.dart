import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState());

  void loadAdmins() async {
    _loadUsersByRole('Admin', UsersStatus.adminSuccess);
  }

  void loadUsers() async {
    _loadUsersByRole('User', UsersStatus.userSuccess);
  }

  void loadSuperAdmins() async {
    _loadUsersByRole('SuperAdmin', UsersStatus.superAdminSuccess);
  }

  Future<void> _loadUsersByRole(String role, UsersStatus successStatus) async {
    emit(state.copyWith(status: UsersStatus.loading));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: role)
          .get();
      final users = snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      emit(state.copyWith(
        admins: role == 'Admin' ? users : state.admins,
        users: role == 'User' ? users : state.users,
        superAdmins: role == 'SuperAdmin' ? users : state.superAdmins,
        status: successStatus,
      ));
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  Future<void> deleteUser(String userId) async {
    await _updateUserRole(userId, null, 'delete');
  }

  Future<void> makeAdmin(String userId) async {
    await _updateUserRole(userId, 'Admin');
  }

  Future<void> demoteAdmin(String userId) async {
    await _updateUserRole(userId, 'User');
  }

  Future<void> makeSuperAdmin(String userId) async {
    await _updateUserRole(userId, 'SuperAdmin');
  }

  Future<void> demoteSuperAdmin(String userId) async {
    await _updateUserRole(userId, 'User');
  }

  Future<void> _updateUserRole(String userId, String? role, [String action = 'update']) async {
    emit(state.copyWith(status: UsersStatus.loading));
    try {
      if (action == 'delete') {
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      } else {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({'role': role});
      }
      // Reload the users list as the data might have changed
      loadAdmins();
      loadUsers();
      loadSuperAdmins();
    } catch (e) {
      emit(state.copyWith(status: UsersStatus.error));
    }
  }

  void currentUserRole() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(state.copyWith(status: UsersStatus.error));
      return;
    }

    FirebaseFirestore.instance.collection('users').doc(userId).get().then((doc) {
      String? role = doc.data()?['role'];
      emit(state.copyWith(currentUserRole: role ?? '', status: UsersStatus.initial));
    }).catchError((_) {
      emit(state.copyWith(status: UsersStatus.error));
    });
  }
}