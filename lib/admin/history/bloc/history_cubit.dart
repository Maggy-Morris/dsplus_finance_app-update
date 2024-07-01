import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final int limit = 3;

  OrderHistoryCubit()
      : super(OrderHistoryState(
    status: OrderHistoryStateStatus.initial,
    documents: [],
    selectedFilter: 'All',
  ));

  Future<void> fetchMoreData() async {
    if (state.status == OrderHistoryStateStatus.loading || !state.hasMoreData) {
      return;
    }

    emit(state.copyWith(status: OrderHistoryStateStatus.loading));

    Query query = FirebaseFirestore.instance.collection("transactions").orderBy("createdAt" , descending: true).limit(limit);

    if (state.selectedFilter != 'All') {
      query = query.where('status', isEqualTo: state.selectedFilter);
    }

    if (state.lastDocument != null) {
      query = query.startAfterDocument(state.lastDocument!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.loaded,
        lastDocument: snapshot.docs.last,
        documents: List.from(state.documents)..addAll(snapshot.docs),
        hasMoreData: snapshot.docs.length >= limit,
      ));
    } else {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.noMoreData,
        hasMoreData: false,
      ));
    }
  }

  Future<void> fetchAllData() async {
    emit(state.copyWith(status: OrderHistoryStateStatus.loading, documents: [], lastDocument: null));

    Query query = FirebaseFirestore.instance.collection("transactions").orderBy("createdAt" , descending: true).limit(limit);

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.loaded,
        lastDocument: snapshot.docs.last,
        documents: snapshot.docs,
        hasMoreData: snapshot.docs.length >= limit,
      ));
    } else {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.noMoreData,
        hasMoreData: false,
      ));
    }
  }

  Future<void> fetchApprovedData() async {
    emit(state.copyWith(status: OrderHistoryStateStatus.loading, documents: [], lastDocument: null));

    Query query = FirebaseFirestore.instance
        .collection("transactions")
        .where("status", isEqualTo: "Approved").orderBy("createdAt" , descending: true)
        .limit(limit);

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.loaded,
        lastDocument: snapshot.docs.last,
        documents: snapshot.docs,
        hasMoreData: snapshot.docs.length >= limit,
      ));
    } else {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.noMoreData,
        hasMoreData: false,
      ));
    }
  }

  Future<void> fetchPendingData() async {
    emit(state.copyWith(status: OrderHistoryStateStatus.loading, documents: [], lastDocument: null));

    Query query = FirebaseFirestore.instance
        .collection("transactions")
        .where("status", isEqualTo: "pending").orderBy("createdAt" , descending: true)
        .limit(limit);

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.loaded,
        lastDocument: snapshot.docs.last,
        documents: snapshot.docs,
        hasMoreData: snapshot.docs.length >= limit,
      ));
    } else {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.noMoreData,
        hasMoreData: false,
      ));
    }
  }

  Future<void> fetchRejectedData() async {
    emit(state.copyWith(status: OrderHistoryStateStatus.loading, documents: [], lastDocument: null));

    Query query = FirebaseFirestore.instance
        .collection("transactions")
        .where("status", isEqualTo: "Rejected").orderBy("createdAt" , descending: true)
        .limit(limit);

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.loaded,
        lastDocument: snapshot.docs.last,
        documents: snapshot.docs,
        hasMoreData: snapshot.docs.length >= limit,
      ));
    } else {
      emit(state.copyWith(
        status: OrderHistoryStateStatus.noMoreData,
        hasMoreData: false,
      ));
    }
  }

  void applySelectedFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter, documents: [], lastDocument: null));
    if (filter == 'All') {
      fetchAllData();
    } else if (filter == 'Approved') {
      fetchApprovedData();
    } else if (filter == 'pending') {
      fetchPendingData();
    } else if (filter == 'Rejected') {
      fetchRejectedData();
    }
  }

}
