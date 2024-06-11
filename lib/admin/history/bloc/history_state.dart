// Cubit State
import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum OrderHistoryStatus { initial, loading, loaded, error }

class OrderHistoryState extends Equatable{
  final String selectedFilter;
  final String filter;
  final List<RequestModel> orders;
  final OrderHistoryStatus status;
  final String error;

  OrderHistoryState({
    this.orders = const [],
    this.status = OrderHistoryStatus.initial,
    this.error = '',
    this.selectedFilter = '',
    this.filter = '',
  });

  OrderHistoryState copyWith({
    List<RequestModel>? users,
    OrderHistoryStatus? status,
    String? error,
    String? selectedFilter,
    String? filter,
    TextEditingController? searchController,
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      error: error ?? this.error,
      orders: users ?? this.orders,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [orders, status, error, selectedFilter, filter, ];
}