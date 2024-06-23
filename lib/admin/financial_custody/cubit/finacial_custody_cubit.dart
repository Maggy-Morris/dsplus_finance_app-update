import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/transactions_attachments_model.dart';
import 'finacial_custody_state.dart';

class FinancialAttachmentCubit extends Cubit<FinancialAttachmentState> {
  FinancialAttachmentCubit() : super(FinancialAttachmentState());

  applyDiscount(
      {required num discountAmount,
      num? currentAmount,
      required String docId}) async {
    emit(state.copyWith(status: FinancialAttachmentStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(docId)
          .update({'amount': currentAmount! - discountAmount});
      emit(state.copyWith(
        status: FinancialAttachmentStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FinancialAttachmentStatus.error,
        error: 'Failed to update amount: $e',
      ));
    }
    emit(state.copyWith(updatedAmount: null));
  }

  getAmount({required String docId}) {
    // emit(state.copyWith(status: OrderDetailsStatus.loading));
    try {
      FirebaseFirestore.instance
          .collection('transactions')
          .doc(docId)
          .get()
          .then((value) {
        final data = value.data();
        final amount = data!['amount'] ?? 0.0;
        emit(
          state.copyWith(
            status: FinancialAttachmentStatus.loaded,
            currentAmount: amount,
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(
        status: FinancialAttachmentStatus.error,
        error: 'Failed to fetch amount: $e',
      ));
    }
    return Stream.empty();
  }

  fetchTransactionsAttachments({required String docId}) async {
    emit(state.copyWith(status: FinancialAttachmentStatus.loading));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .doc(docId)
          .collection('attachments')
          .get();
      final transactionsAttachments = snapshot.docs.map((doc) {
        final data = doc.data();
        return TransactionsAttachmentsModel(
          status: data['status'] ?? "",
          amount: data['amount'] ?? 0.0,
          createdAt: data['createdAt'] ?? "",
          description: data['description'] ?? "",
          imageUrl: data['imageUrl'] ?? "",
          transactionId: data['id'] ?? "",
          reason: data['reason'] ?? "",
        );
      }).toList();
      emit(state.copyWith(
        status: FinancialAttachmentStatus.loaded,
        attachments: transactionsAttachments,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FinancialAttachmentStatus.error,
        error: 'Failed to fetch attachments: $e',
      ));
    }
  }

  approveBudget({required String docId, required String attId}) async {
    emit(state.copyWith(status: FinancialAttachmentStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(docId)
          .collection('attachments')
          .doc(attId)
          .update({'status': 'Approved'});
      emit(state.copyWith(status: FinancialAttachmentStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: FinancialAttachmentStatus.error,
        error: 'Failed to approve budget: $error',
      ));
    }
  }

  rejectBudget(
      {required String docId,
      required String reason,
      required String attId}) async {
    emit(state.copyWith(status: FinancialAttachmentStatus.loading));
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(docId)
          .collection('attachments')
          .doc(attId)
          .update({'status': 'Rejected', 'reason': reason});
      emit(state.copyWith(status: FinancialAttachmentStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: FinancialAttachmentStatus.error,
        error: 'Failed to reject budget: $error',
      ));
    }
  }
}

//clear state.updateAmount
