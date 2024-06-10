// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// Widget buildBudgetCard(Map<String, dynamic> userData,
//     Map<String, dynamic> budgetData, DateTime startDate, DateTime endDate) {
//   return Card(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(15),
//     ),
//     margin: EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildListTile("User Email", userData['Email'] ?? ''),
//         buildListTile("Budget Name", budgetData['name'] ?? ''),
//         buildListTile("Amount", budgetData['amount']?.toString() ?? ''),
//         buildListTile("Budget Type", budgetData['budgetType'] ?? ''),
//         buildListTile("Status", budgetData['status'] ?? ''),
//         buildListTile("Start Date", DateFormat('dd/MM/yyyy').format(startDate)),
//         buildListTile("End Date", DateFormat('dd/MM/yyyy').format(endDate)),
//         if (budgetData['status'] ==
//             'Rejected') // Show reason for rejected orders
//           buildListTile("Reason for Rejection", budgetData['reason'] ?? ''),
//         SizedBox(height: 10),
//       ],
//     ),
//   );
// }
// ListTile buildListTile(String title, String subtitle) {
//   return ListTile(
//     title: Text(
//       title,
//       style: TextStyle(fontWeight: FontWeight.bold),
//     ),
//     subtitle: Text(
//       subtitle,
//       style: TextStyle(fontSize: 17),
//     ),
//   );
// }
