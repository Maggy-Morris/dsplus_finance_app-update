import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../requests/model/request_model.dart';
import 'history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(OrderHistoryState());

  void applyFilter(String query) {
    if (state.status == OrderHistoryStatus.loaded) {
      final newFilter = query.toLowerCase();
      emit(state.copyWith(filter: newFilter));
    }
  }

  void applySelectedFilter(String newFilter) {
    if (state.status == OrderHistoryStatus.loaded) {
      if (newFilter == 'All') {
        emit(state.copyWith(selectedFilter: newFilter, filter: ''));
      } else {
        emit(state.copyWith(selectedFilter: newFilter));
      }
    }
  }

  void fetchData(int batchSize) async {
    emit(state.copyWith(status: OrderHistoryStatus.loading));

    try {
      final snapshot = await FirebaseFirestore.instance.collection('transactions')                       .orderBy('date', descending: true) // Assuming 'date' is the field to order by
          .orderBy('date', descending: true)
          .limit(batchSize).get();

      final orders = snapshot.docs.map((doc) => RequestModel.toMap(doc)).toList();
      emit(state.copyWith(
        users: orders,
        selectedFilter: 'All',
        filter: '',
        status: OrderHistoryStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: OrderHistoryStatus.error, error: 'Failed to fetch data: $e'));
    }
  }
}
