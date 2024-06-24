import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

enum OrderHistoryStatus { initial, loading, loaded, error }

class OrderHistoryState extends Equatable {
  final String selectedFilter; // Holds the currently selected filter
  final String filter; // Holds the current filter text
  final List<RequestModel> orders; // List of order models
  final OrderHistoryStatus status; // Current status of the state
  final String error; // Error message if an error occurs
  final DocumentSnapshot? lastDocument; // Last fetched document for pagination

  OrderHistoryState({
    this.orders = const [], // Default empty list of orders
    this.status = OrderHistoryStatus.initial, // Default status is initial
    this.error = '', // Default empty error message
    this.selectedFilter = '', // Default empty selected filter
    this.filter = '', // Default empty filter text
    this.lastDocument, // Default is null
  });

  // Copy constructor to create a new state object with updated values
  OrderHistoryState copyWith({
    List<RequestModel>? users,
    OrderHistoryStatus? status,
    String? error,
    String? selectedFilter,
    String? filter,
    DocumentSnapshot? lastDocument,
    TextEditingController? searchController, // Unused in current implementation
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      error: error ?? this.error,
      orders: users ?? this.orders,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      filter: filter ?? this.filter,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }

  @override
  List<Object?> get props =>
      [orders, status, error, selectedFilter, filter, lastDocument];

  // Equatable comparison method to determine equality between state objects
  @override
  bool get stringify => true; // Enables toString implementation for Equatable
}
