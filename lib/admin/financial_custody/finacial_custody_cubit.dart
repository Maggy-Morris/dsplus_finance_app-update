import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'finacial_custody_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> budgetData;
  double? updatedAmount; // Store the updated amount

  OrderDetailsCubit({required this.userData, required this.budgetData})
      : super(OrderDetailsInitial());

  void applyDiscount(double discountAmount) async {
    try {
      emit(OrderDetailsLoading());
      final currentAmount = budgetData['amount'];
      final updatedAmount = currentAmount - discountAmount;

      final budgetId = budgetData['id'];

      if (budgetId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userData['userId'] as String)
            .collection('transactions')
            .doc(budgetId)
            .update({'amount': updatedAmount});

        // Store the updated amount and emit the new state
        this.updatedAmount = updatedAmount;
        emit(OrderDetailsInitial()); // Reset state
      } else {
        emit(OrderDetailsError('Budget ID is null. Cannot update amount.'));
      }
    } catch (e) {
      emit(OrderDetailsError('Failed to apply discount: $e'));
    }
  }
}
