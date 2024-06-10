import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin.dart';
import 'requests_state.dart';

class AdminRequestsCubit extends Cubit<AdminRequestsState> {
  late StreamSubscription<QuerySnapshot> _subscription;

  AdminRequestsCubit() : super(AdminRequestsState(users: [])) {
    fetchData();
  }

  void fetchData() {
    try {
      _subscription = FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'User')
          .snapshots()
          .listen((snapshot) {
        final List<DocumentSnapshot> users = snapshot.docs;
        emit(AdminRequestsState(users: users));
      }, onError: (error) {
      });
    } catch (e) {
    }
  }

  void approveBudget(String userId, String budgetId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(budgetId)
          .update({'status': 'Approved'});
      fetchData(); // Refresh data after approval
      print("Budget approved successfully!");
    } catch (error) {
      print("Failed to approve budget: $error");
    }
  }

  void rejectBudget(String userId, String budgetId, String reason) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(budgetId)
          .update({'status': 'Rejected', 'reason': reason});
      fetchData(); // Refresh data after rejection
      print("Budget rejected successfully!");
    } catch (error) {
      print("Failed to reject budget: $error");
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
