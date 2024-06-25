import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../requests/model/request_model.dart';
import 'history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final int limit = 3;

  OrderHistoryCubit()
      : super(OrderHistoryState(
    status: OrderHistoryStateStatus.initial,
    documents: [],
  ));

  Future<void> fetchMoreData() async {
    if (state.status == OrderHistoryStateStatus.loading || !state.hasMoreData) {
      return;
    }

    emit(state.copyWith(status: OrderHistoryStateStatus.loading));

    Query query =
    FirebaseFirestore.instance.collection("transactions").limit(limit);

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
}

//
// class OrderHistoryCubit extends Cubit<OrderHistoryState> {
//   OrderHistoryCubit() : super(OrderHistoryState());
//
//   void applyFilter(String query) {
//     if (state.status == OrderHistoryStatus.loaded) {
//       final newFilter = query.toLowerCase();
//       emit(state.copyWith(filter: newFilter));
//     }
//   }
//
//   void applySelectedFilter(String newFilter) {
//     if (state.status == OrderHistoryStatus.loaded) {
//       if (newFilter == 'All') {
//         emit(state.copyWith(selectedFilter: newFilter, filter: ''));
//       } else {
//         emit(state.copyWith(selectedFilter: newFilter));
//       }
//     }
//   }
//
//   Future<void> fetchData(int batchSize) async {
//
//     emit(state.copyWith(isLoading: true, status: OrderHistoryStatus.loading));
//
//     try {
//       Query query = FirebaseFirestore.instance
//           .collection('transactions')
//           .orderBy('date', descending: true)
//           .limit(batchSize);
//
//       if (state.lastDocument != null) {
//         query = query.startAfterDocument(state.lastDocument!);
//       }
//
//       final snapshot = await query.get();
//       if (snapshot.docs.isNotEmpty) {
//         if (snapshot.docs.length < 3) {
//           emit(state.copyWith(
//             hasMoreData: false,
//           ));
//           return;
//         }
//
//         emit(state.copyWith(
//           status: OrderHistoryStatus.loaded,
//           isLoading: false,
//           lastDocument: snapshot.docs.last,
//           orders:
//           snapshot.docs.map((doc) => RequestModel.toMap(doc)).toList(),
//         ));
//         return;
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         status: OrderHistoryStatus.error,
//         error: 'Failed to fetch data: $e',
//         isLoading: false,
//       ));
//     }
//   }
//   void fetchMoreData() async {
//     if (state.isLoading || !state.hasMoreData) return;
//
//     try {
//       Query query = FirebaseFirestore.instance
//           .collection('transactions')
//           .limit(3);
//
//       if (state.lastDocument != null) {
//         query.startAfterDocument(state.lastDocument!);
//       }
//
//       final snapshot = await query.get();
//       if (snapshot.docs.isNotEmpty) {
//         if (snapshot.docs.length < 3) {
//           emit(state.copyWith(
//             hasMoreData: false,
//           ));
//         }
//
//         emit(state.copyWith(
//           status: OrderHistoryStatus.loaded,
//           isLoading: false,
//           lastDocument: snapshot.docs.last,
//           orders: snapshot.docs.map((doc) => RequestModel.toMap(doc)).toList(),
//         ));
//       } else {
//         emit(state.copyWith(
//           hasMoreData: false,
//           isLoading: false,
//         ));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         status: OrderHistoryStatus.error,
//         error: 'Failed to fetch more data: $e',
//         isLoading: false,
//       ));
//     }
//   }
//
// }
