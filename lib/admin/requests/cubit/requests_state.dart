import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:dsplus_finance/admin/requests/model/request_model.dart';

enum AdminRequestsStatus { initial, loading, loaded, error }

class AdminRequestsState extends Equatable {
  final List<RequestModel> requests;
  final AdminRequestsStatus status;
  final String error;
  final bool hasMoreData;
  final DocumentSnapshot? lastDocument;

  final int numberOfRequests;

  AdminRequestsState({
    required this.requests,
    required this.status,
    this.error = '',
    this.hasMoreData = true,
    this.lastDocument,
    this.numberOfRequests = 0,
  });

  AdminRequestsState copyWith({
    List<RequestModel>? requests,
    AdminRequestsStatus? status,
    String? error,
    bool? hasMoreData,
    DocumentSnapshot? lastDocument,
    int? numberOfRequests,
  }) {
    return AdminRequestsState(
      requests: requests ?? this.requests,
      status: status ?? this.status,
      error: error ?? this.error,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      lastDocument: lastDocument ?? this.lastDocument,
      numberOfRequests: numberOfRequests ?? this.numberOfRequests,
    );
  }

  @override
  List<Object?> get props => [requests, status, error, hasMoreData, lastDocument , numberOfRequests];
}
