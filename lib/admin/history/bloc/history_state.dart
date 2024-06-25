import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderHistoryStateStatus { initial, loading, loaded, noMoreData }

class OrderHistoryState extends Equatable{
  final OrderHistoryStateStatus status;
  final List<DocumentSnapshot> documents;
  final DocumentSnapshot? lastDocument;
  final bool hasMoreData;


  OrderHistoryState({
    required this.status,
    required this.documents,
    this.lastDocument,
    this.hasMoreData = true,
  });

  OrderHistoryState copyWith({
    OrderHistoryStateStatus? status,
    List<DocumentSnapshot>? documents,
    DocumentSnapshot? lastDocument,
    bool? hasMoreData,
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      lastDocument: lastDocument ?? this.lastDocument,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status,documents,lastDocument,hasMoreData];
}

// import 'package:equatable/equatable.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dsplus_finance/admin/requests/model/request_model.dart';
//
// enum OrderHistoryStatus { initial, loading, loaded, error }
//
// class OrderHistoryState extends Equatable {
//   final List<RequestModel> orders;
//   final String selectedFilter;
//   final String filter;
//   final OrderHistoryStatus status;
//   final String error;
//   DocumentSnapshot? lastDocument;
//   final bool isLoading;
//   final bool hasMoreData;
//
//   OrderHistoryState({
//     this.orders = const [],
//     this.status = OrderHistoryStatus.initial,
//     this.error = '',
//     this.selectedFilter = 'All',
//     this.filter = '',
//     this.lastDocument,
//     this.isLoading = false,
//     this.hasMoreData = true,
//   });
//
//   OrderHistoryState copyWith({
//     List<RequestModel>? orders,
//     OrderHistoryStatus? status,
//     String? error,
//     String? selectedFilter,
//     String? filter,
//     DocumentSnapshot? lastDocument,
//     bool? isLoading,
//     bool? hasMoreData,
//   }) {
//     return OrderHistoryState(
//       orders: orders ?? this.orders,
//       status: status ?? this.status,
//       error: error ?? this.error,
//       selectedFilter: selectedFilter ?? this.selectedFilter,
//       filter: filter ?? this.filter,
//       lastDocument: lastDocument ?? this.lastDocument,
//       isLoading: isLoading ?? this.isLoading,
//       hasMoreData: hasMoreData ?? this.hasMoreData,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     orders,
//     status,
//     error,
//     selectedFilter,
//     filter,
//     lastDocument,
//     isLoading,
//     hasMoreData,
//   ];
//
//
// }
