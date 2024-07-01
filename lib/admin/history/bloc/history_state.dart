import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderHistoryStateStatus { initial, loading, loaded, noMoreData }


class OrderHistoryState extends Equatable {
  final OrderHistoryStateStatus status;
  final List<DocumentSnapshot> documents;
  final DocumentSnapshot? lastDocument;
  final bool hasMoreData;
  final String selectedFilter;

  OrderHistoryState({
    required this.status,
    required this.documents,
    this.lastDocument,
    this.hasMoreData = true,
    required this.selectedFilter,
  });

  OrderHistoryState copyWith({
    OrderHistoryStateStatus? status,
    List<DocumentSnapshot>? documents,
    DocumentSnapshot? lastDocument,
    bool? hasMoreData,
    String? selectedFilter,
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      lastDocument: lastDocument ?? this.lastDocument,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [status, documents, lastDocument, hasMoreData, selectedFilter];
}
