import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:equatable/equatable.dart';

import '../model/transactions_attachments_model.dart';

enum FinancialAttachmentStatus { initial, loading, loaded, error }

class FinancialAttachmentState extends Equatable {
  final List<TransactionsAttachmentsModel>? attachments;
  final FinancialAttachmentStatus status;
  final String error;
  final num? updatedAmount;
  final num? currentAmount;

  FinancialAttachmentState({
    this.attachments,
    this.status = FinancialAttachmentStatus.initial,
    this.error = '',
    this.updatedAmount,
    this.currentAmount,
  });

  FinancialAttachmentState copyWith({
    List<TransactionsAttachmentsModel>? attachments,
    FinancialAttachmentStatus? status,
    String? error,
    num? updatedAmount,
    num? currentAmount,
  }) {
    return FinancialAttachmentState(
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      error: error ?? this.error,
      updatedAmount: updatedAmount ?? this.updatedAmount,
      currentAmount: currentAmount ?? this.currentAmount,
    );
  }

  @override
  List<Object?> get props => [attachments, status, error, updatedAmount , currentAmount];
}
