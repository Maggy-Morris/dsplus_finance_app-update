import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'requests_state.dart';

class AdminRequestsCubit extends Cubit<AdminRequestsState> {
  static const int limit = 2; // Number of documents to fetch per page

  AdminRequestsCubit()
      : super(AdminRequestsState(
      requests: [],
      status: AdminRequestsStatus.initial,
      hasMoreData: true,
      lastDocument: null));

   fetchMoreData() async {
    if (state.status == AdminRequestsStatus.loading || !state.hasMoreData) {
      return;
    }

    emit(state.copyWith(status: AdminRequestsStatus.loading));

    Query query = FirebaseFirestore.instance
        .collection('transactions')
        .where('status', isEqualTo: "pending")
        .orderBy("createdAt", descending: true)
        .limit(limit);

    if (state.requests.isNotEmpty) {
      query = query.startAfterDocument(state.lastDocument!);
    }

    try {
      final querySnapshot = await query.get();

      final requests = querySnapshot.docs
          .map((doc) => RequestModel.toMap(doc))
          .toList()
          .cast<RequestModel>();

      emit(state.copyWith(
        requests: List.from(state.requests)..addAll(requests),
        status: AdminRequestsStatus.loaded,
        lastDocument: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
        hasMoreData: querySnapshot.docs.length >= limit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdminRequestsStatus.error,
        error: 'Failed to fetch more data: $e',
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
      state.requests.clear();
      emit(state.copyWith(status: AdminRequestsStatus.approved));
    } catch (error) {
      emit(state.copyWith(
        status: AdminRequestsStatus.error,
        error: 'Failed to approve budget: $error',
      ));
    }
  }

  Future<void> rejectBudget(String budgetId, String reason) async {
    emit(state.copyWith(status: AdminRequestsStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(budgetId)
          .update({'status': 'Rejected', 'reason': reason});
      state.requests.clear();
      emit(state.copyWith(status: AdminRequestsStatus.rejected));
    } catch (error) {
      emit(state.copyWith(
        status: AdminRequestsStatus.error,
        error: 'Failed to reject budget: $error',
      ));
    }
  }

  void numberOfRequests() {
    FirebaseFirestore.instance
        .collection('transactions')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      emit(state.copyWith(numberOfRequests: snapshot.docs.length));
    });
  }
}
