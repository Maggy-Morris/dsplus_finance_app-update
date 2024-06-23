// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Banner {
  final String id;
  final String imageUrl;
  final String description;
  final double amount;
  final String status;

  // String creatorId;
  // List<String> shopListId;
  // bool isApproved;
  int createdAt;
  Banner({
    required this.amount,
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.status,
    // required this.shopListId,
    // required this.isApproved,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
      'amount': amount,
      'status': status,
      // 'shopListId': shopListId,
      // 'isApproved': isApproved,
      'createdAt': createdAt,
    };
  }

  factory Banner.fromMap(Map<String, dynamic> map) {
    return Banner(
      amount: map['amount'] as double,
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      // creatorId: map['creatorId'] as String,
      // shopListId: List<String>.from((map['shopListId'])),
      // isApproved: map['isApproved'] as bool,
      createdAt: map['createdAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Banner.fromJson(String source) =>
      Banner.fromMap(json.decode(source) as Map<String, dynamic>);
}
