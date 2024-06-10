import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(OrderHistoryLoading());

  void applyFilter(String query) {
    if (state is OrderHistoryLoaded) {
      final currentState = state as OrderHistoryLoaded;
      final newFilter = query.toLowerCase();
      emit(OrderHistoryLoaded(
        users: currentState.users,
        selectedFilter: currentState.selectedFilter,
        filter: newFilter,
        searchController: currentState.searchController,
      ));
    }
  }

  void applySelectedFilter(String newFilter) {
    if (state is OrderHistoryLoaded) {
      final currentState = state as OrderHistoryLoaded;
      emit(OrderHistoryLoaded(
        users: currentState.users,
        selectedFilter: newFilter,
        filter: currentState.filter,
        searchController: currentState.searchController,
      ));
    }
  }

  // void resetSearch() {
  //   if (state is OrderHistoryLoaded) {
  //     final currentState = state as OrderHistoryLoaded;
  //     currentState.searchController.clear();
  //     emit(OrderHistoryLoaded(
  //       users: currentState.users,
  //       selectedFilter: currentState.selectedFilter,
  //       filter: '',
  //       searchController: currentState.searchController,
  //     ));
  //   }
  // }
  // void clearSearch() {
  //   if (state is OrderHistoryLoaded) {
  //     final currentState = state as OrderHistoryLoaded;
  //     currentState.searchController.clear();
  //     currentState.filter = ''; // Clear the filter text in the current state
  //   }
  // }

  void fetchData() async {
    try {
      //emit(OrderHistoryLoading());
      final snapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'User').get();
      emit(OrderHistoryLoaded(
        users: snapshot.docs.length > 0 ? snapshot.docs : [],
        selectedFilter: 'All',
        filter: '',
        searchController: TextEditingController(),
      ));
    } catch (e) {
      emit(OrderHistoryError('Failed to fetch data: $e'));
    }
  }
}
