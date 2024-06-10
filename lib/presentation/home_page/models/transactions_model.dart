import 'package:equatable/equatable.dart';

class TransactionsModel extends Equatable {
  String? reason;
  String? id;
  String? name;
  double? amount;
  String? date;
  String? expectedDate;
  String? type;
  String? status;
  List<dynamic>? attachments;
  bool? cashOrCredit;
  num? accountNumber; 

  String? bankName;

  TransactionsModel({
    this.reason,
    this.id,
    this.name,
    this.amount,
    this.date,
    this.expectedDate,
    this.type,
    this.status,
    this.attachments,
    this.cashOrCredit,
    this.accountNumber,
    this.bankName,
  });

  TransactionsModel.fromJson(Map<String, dynamic> json, this.id) {
    reason = json['reason'];
    id = json['id'];

    name = json['name'];
    amount = json['amount'] ?? ''; // Parse to double
    date = json['date'];
    expectedDate = json['expected_date'];
    type = json['type'];
    status = json['status'];
    attachments = json['attachments'];
    cashOrCredit = json['cashOrCredit'];
    accountNumber =
        num.tryParse(json['accountNumber'] ?? ''); // Parse to double
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['reason'] = this.reason;
    data['id'] = this.id;

    data['name'] = this.name;
    data['amount'] = this.amount; // Convert double to string
    data['date'] = this.date;
    data['expected_date'] = this.expectedDate;
    data['type'] = this.type;
    data['status'] = this.status;
    data['attachments'] = this.attachments;
    data['cashOrCredit'] = this.cashOrCredit;
    data['accountNumber'] =
        this.accountNumber?.toString(); // Convert num to string
    data['bankName'] = this.bankName;

    return data;
  }

  TransactionsModel copyWith({
    String? reason,
    String? id,
    String? name,
    double? amount,
    String? date,
    String? expectedDate,
    String? type,
    String? status,
    List<dynamic>? attachments,
    bool? cashOrCredit,
    double? accountNumber,
    String? bankName,
  }) {
    return TransactionsModel(
      reason: reason ?? this.reason,
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      expectedDate: expectedDate ?? this.expectedDate,
      type: type ?? this.type,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      cashOrCredit: cashOrCredit ?? this.cashOrCredit,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
    );
  }

  @override
  List<Object?> get props => [
    reason,
        id,
        name,
        amount,
        date,
        expectedDate,
        type,
        status,
        attachments,
        cashOrCredit,
        accountNumber,
        bankName,
      ];
}
