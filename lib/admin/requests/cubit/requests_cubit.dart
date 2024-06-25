import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../requests.dart';
import 'requests_state.dart';

class AdminRequestsCubit extends Cubit<AdminRequestsState> {
  late final StreamSubscription<QuerySnapshot> _subscription;

  AdminRequestsCubit()
      : super(AdminRequestsState(
            requests: [], status: AdminRequestsStatus.initial)) {
    _subscription = FirebaseFirestore.instance
        .collection('transactions')
        .where('status', isEqualTo: "pending")
        .snapshots()
        .listen((snapshot) {
      final requests = snapshot.docs.map((doc) {
        final data = doc.data();
        return RequestModel(
          docId: doc.id,
          userId: data['User'] ?? "",
          amount: data['amount'] ?? 0.0,
          status: data['status'] ?? "",
          email: data["email"] ?? "",
          budgetName: data["name"] ?? "",
          type: data["type"] ?? "",
          reason: data["reason"] ?? "",
          date: data["date"] ?? "",
          expected_date: data["expected_date"] ?? "",
          accountNumber: data["accountNumber"] ?? 0.0,
          attachments: List<String>.from(data["attachments"] ?? []),
          bankName: data["bankName"] ?? "",
          cashOrCredit: data["cashOrCredit"] ?? false,
          userName: data["userName"] ?? "",
        );
      }).toList();

      emit(state.copyWith(
          requests: requests, status: AdminRequestsStatus.loaded));
    });
  }

  void fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('status', isEqualTo: "pending")
          .get();

      final requests =
          querySnapshot.docs.map((doc) => RequestModel.toMap(doc)).toList();

      emit(state.copyWith(
          requests: requests, status: AdminRequestsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: AdminRequestsStatus.error,
        error: 'Failed to fetch data: $e',
      ));
    }
  }

  Future<void> approveBudget(String budgetId) async {
    emit(state.copyWith(status: AdminRequestsStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(budgetId)
          .update({'status': 'Approved'});
      fetchData(); // Refresh data after approval
      emit(state.copyWith(status: AdminRequestsStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: AdminRequestsStatus.error,
        error: 'Failed to approve budget: $error',
      ));
    }
  }

  Future<void> rejectBudget(String budgetId, String reason) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(budgetId)
          .update({'status': 'Rejected', 'reason': reason});
      fetchData(); // Refresh data after rejection
      emit(state.copyWith(status: AdminRequestsStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: AdminRequestsStatus.error,
        error: 'Failed to reject budget: $error',
      ));
    }
  }

  Stream<int> numberOfRequests() {
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

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
