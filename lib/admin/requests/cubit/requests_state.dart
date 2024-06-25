import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:equatable/equatable.dart';

enum AdminRequestsStatus { initial, loading, loaded, error }
class AdminRequestsState extends Equatable {
  final List<dynamic>? requests;
  final AdminRequestsStatus status;
  final String error;
  

  AdminRequestsState({
    this.requests,
    this.status = AdminRequestsStatus.initial,
    this.error = '',
  });

  AdminRequestsState copyWith({
    List<dynamic>? requests,
    AdminRequestsStatus? status,
    String? error,
  }) {
    return AdminRequestsState(
      status: status ?? this.status,
      error: error ?? this.error,
      requests: requests ?? this.requests,
    );
  }
  @override
  List<Object?> get props => [requests, status, error];
}
