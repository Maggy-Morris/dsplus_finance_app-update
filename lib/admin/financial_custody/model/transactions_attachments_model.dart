import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionsAttachmentsModel extends Equatable {
  num amount;
  String transactionId;
  String description;
  Timestamp createdAt;
  String imageUrl;
  String status;
  String reason;


  TransactionsAttachmentsModel({
    required this.amount,
    required this.transactionId,
    required this.description
    ,
    required this.createdAt,
    required this.imageUrl,
    required this.status,
    this.reason = "",
  });

  TransactionsAttachmentsModel copyWith({
    double? amount,
    String? transactionId,
    String? description,
    Timestamp? createdAt,
    String? imageUrl,
    String? status,
    String? reason,
  }) {
    return TransactionsAttachmentsModel(
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }

  factory TransactionsAttachmentsModel.fromJson(Map<String, dynamic> json) {
    return TransactionsAttachmentsModel(
      amount: json['amount'],
      transactionId: json['transactionId'],
      description: json['description'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'transactionId': transactionId,
      'description': description,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'status': status,
      'reason': reason,
    };
  }

  factory TransactionsAttachmentsModel.toMap(Map<String, dynamic> map) {
    return TransactionsAttachmentsModel(
      amount: map['amount'],
      transactionId: map['transactionId'],
      description: map['description'],
      createdAt: map['createdAt'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      reason: map['reason'],
    );
  }
@override
List<Object?> get props => [amount, transactionId, description, createdAt, imageUrl, status , reason];
}