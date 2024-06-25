import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

final class RequestModel extends Equatable {
  final String docId;
  final String budgetName; // Updated
  final String? email;
  final num? amount;
  final String? type;
  final String? status;
  final String userId;
  final String? date;
  final String? expected_date;
  final num? accountNumber;
  final List<dynamic> attachments;
  final String? bankName;
  final bool cashOrCredit;
  final String? reason;
  final String userName;

  RequestModel({
    required this.date,
    required this.expected_date,
    required this.userId,
    required this.email,
    required this.amount,
    required this.type,
    required this.status,
    required this.budgetName,
    required this.accountNumber,
    required this.attachments,
    required this.bankName,
    required this.cashOrCredit,
    required this.reason,
    required this.docId,
    required this.userName,
  });


  factory RequestModel.toMap(QueryDocumentSnapshot<Object?> map) {
    return RequestModel(
      docId: map.id,
      expected_date: map['expected_date'] ?? "",
      date: map['date'] ?? "",
      userId: map['id']?? "",
      budgetName: map['name']?? "",
      email: map['email']?? "",
      amount: map['amount']?? 0.0,
      type: map['type']?? "",
      status: map['status']?? "",
      accountNumber: map['accountNumber']?? 0.0,
      attachments: map['attachments']?? [],
      bankName: map['bankName']?? "",
      cashOrCredit: map['cashOrCredit']?? false,
      reason: map['reason']?? "",
      userName: map['userName']?? "",
    );
  }

  toMap() {
    return {
      'expected_date': expected_date,
      'date': date,
      'id': userId,
      'name': budgetName,
      'email': email,
      'amount': amount,
      'type': type,
      'status': status,
      'accountNumber': accountNumber,
      'attachments': attachments,
      'bankName': bankName,
      'cashOrCredit': cashOrCredit,
      'reason': reason,
      'docId': docId,
      'userName': userName,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      docId: map['id']?? "",
      expected_date: map['expected_date'] ?? "",
      date: map['date'] ?? "",
      userId: map['userId']?? "",
      budgetName: map['name']?? "",
      email: map['email']?? "",
      amount: map['amount']?? 0.0,
      type: map['type']?? "",
      status: map['status']?? "",
      accountNumber: map['accountNumber']?? 0.0,
      attachments: map['attachments']?? [],
      bankName: map['bankName']?? "",
      cashOrCredit: map['cashOrCredit']?? false,
      reason: map['reason']?? "",
      userName: map['userName']?? "",
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [
        userId,
        budgetName,
        email,
        amount,
        type,
        status,
        date,
        expected_date,
        accountNumber,
        attachments,
        bankName,
        cashOrCredit,
        reason,
        docId
    ,userName
      ];
}
