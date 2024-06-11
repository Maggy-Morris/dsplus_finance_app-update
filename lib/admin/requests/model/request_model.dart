import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

final class RequestModel extends Equatable {

  final String docId;
  final String name; // Updated
  final String? email;
  final num? amount;
  final String? type;
  final String? status;
  final String userId;
  final String? date;
  final String? expected_date;
  final num? accountNumber;
  final List<String?> attachments;
  final String? bankName;
  final bool cashOrCredit;
  final String? reason;

  RequestModel({
    required this.date,
    required this.expected_date,
    required this.userId,
    required this.email,
    required this.amount,
    required this.type,
    required this.status,
    required this.name,
    required this.accountNumber,
    required this.attachments,
    required this.bankName,
    required this.cashOrCredit,
    required this.reason,
    required this.docId,
  });

  RequestModel copyWith({
    String? userId,
    String? name,
    String? email,
    num? amount,
    String? type,
    String? status,
    String? date,
    String? expected_date,
    num? accountNumber,
    List<String?>? attachments,
    String? bankName,
    bool? cashOrCredit,
    String? reason,
    String? docId,
  }) {
    return RequestModel(
      date: date ?? this.date,
      expected_date: expected_date ?? this.expected_date,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      status: status ?? this.status,
      accountNumber: accountNumber ?? this.accountNumber,
      attachments: attachments ?? this.attachments,
      bankName: bankName ?? this.bankName,
      cashOrCredit: cashOrCredit ?? this.cashOrCredit,
      reason: reason ?? this.reason,
      docId: docId ?? this.docId,

    );
  }


  factory RequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    return RequestModel(
      date: snapshot['date'],
      expected_date: snapshot['expected_date'],
      userId: snapshot['userId'],
      name: snapshot['name'],
      email: snapshot['email'],
      amount: snapshot['amount'],
      type: snapshot['type'],
      status: snapshot['status'],
      accountNumber: snapshot['accountNumber'],
      attachments: snapshot['attachments'],
      bankName: snapshot['bankName'],
      cashOrCredit: snapshot['cashOrCredit'],
      reason: snapshot['reason'],
      docId: snapshot.id,
    );
  }

  factory RequestModel.toMap(Map<String, dynamic> map) {
    return RequestModel(
      expected_date: map['expected_date'],
      date: map['date'],
      userId: map['id'],
      name: map['name'],
      email: map['email'],
      amount: map['amount'],
      type: map['type'],
      status: map['status'],
      accountNumber: map['accountNumber'],
      attachments: map['attachments'],
      bankName: map['bankName'],
      cashOrCredit: map['cashOrCredit'],
      reason: map['reason'],
      docId: map['docId'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userId, name, email, amount, type, status , date , expected_date , accountNumber , attachments , bankName , cashOrCredit , reason , docId];
}
