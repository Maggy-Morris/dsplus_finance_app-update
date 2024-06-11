import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../admin.dart';
import 'requests_state.dart';

class AdminRequestsCubit extends Cubit<AdminRequestsState> {
  late StreamSubscription<QuerySnapshot> _subscription;

  AdminRequestsCubit() : super(AdminRequestsState(requests: [] , status: AdminRequestsStatus.initial)) {
  }


  void fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('status', isEqualTo: "pending")
          .get();

      final orders = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return RequestModel(
          docId: doc.id,
          userId: data['User'] ?? "",
          amount: data['amount'] ?? 0.0,
          status: data['status'] ?? "",
          email: data["email"] ?? "",
          name: data["name"] ?? "",
          type: data["type"] ?? "",
          reason: data["reason"] ?? "",
          date: data["date"] ?? "",
          expected_date: data["expected_date"] ?? "",
          accountNumber: data["accountNumber"] ?? 0.0,
          attachments: List<String>.from(data["attachments"] ?? []),
          bankName: data["bankName"] ?? "",
          cashOrCredit: data["cashOrCredit"] ?? false,
        );
      }).toList();

      emit(state.copyWith(requests: orders, status: AdminRequestsStatus.loaded));
    } catch (e) {
      // Handle error
      throw Exception('Failed to fetch data: $e');
    }
  }
  void approveBudget(String userId, String budgetId) async {
    try {
      await FirebaseFirestore.instance
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
          .collection('transactions')
          .doc(budgetId)
          .update({'status': 'Rejected', 'reason': reason});
      fetchData(); // Refresh data after rejection
      print("Budget rejected successfully!");
    } catch (error) {
      print("Failed to reject budget: $error");
    }
  }

  Stream numberOfRequests() {
    StreamController<int> controller = StreamController<int>();
    FirebaseFirestore.instance
        .collection('transactions')
        .where('status', isEqualTo: "pending")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      controller.add(snapshot.docs.length);
    });
    return controller.stream;
  }

}
