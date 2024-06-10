// Cubit State
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<DocumentSnapshot> users;
  final String selectedFilter;
  late final String filter;
  final TextEditingController searchController;

  OrderHistoryLoaded({
    required this.users,
    required this.selectedFilter,
    required this.filter,
    required this.searchController,
  });
}

class OrderHistoryError extends OrderHistoryState {
  final String errorMessage;

  OrderHistoryError(this.errorMessage);
}