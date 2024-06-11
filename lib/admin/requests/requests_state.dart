import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum AdminRequestsStatus { initial, loading, loaded, error }
class AdminRequestsState extends Equatable {
  final List<DocumentSnapshot> users;
  final AdminRequestsStatus status;
  final String error;

  AdminRequestsState({
    this.users = const [],
    this.status = AdminRequestsStatus.initial,
    this.error = '',
  });

  AdminRequestsState copyWith({
    List<DocumentSnapshot>? users,
    AdminRequestsStatus? status,
    String? error,
  }) {
    return AdminRequestsState(
      users: users ?? this.users,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
  @override
  List<Object?> get props => [users, status, error];
}
