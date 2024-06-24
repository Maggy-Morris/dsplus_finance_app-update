import 'package:dsplus_finance/admin/requests/requests_cubit.dart';
import 'package:dsplus_finance/admin/requests/requests_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminRequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
        builder: (context, state) {
          if (state.users.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final userData =
                  state.users[index].data() as Map<String, dynamic>;
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(state.users[index].id)
                    .collection('transactions')
                    .where('status',
                        whereNotIn: ['Approved', 'Rejected']).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final budgets = snapshot.data!.docs;
                  if (budgets.isEmpty) {
                    return SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...budgets.map((budget) {
                        final budgetData =
                            budget.data() as Map<String, dynamic>;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildListTile(
                                  "User Email", budgetData['Email'] ?? ''),
                              buildListTile(
                                  "Budget Name", budgetData['name'] ?? ''),
                              buildListTile("Amount",
                                  budgetData['amount']?.toString() ?? ''),
                              buildListTile(
                                  "Budget Type", budgetData['type'] ?? ''),
                              buildListTile(
                                  "Status", budgetData['status'] ?? ''),
                              // buildListTile(
                              //   "Start Date",
                              //   formatDate(
                              //     Timestamp.fromDate(
                              //         DateTime.parse(budgetData['date'])),
                              //   ),
                              // ),
                              // buildListTile(
                              //   "End Date",
                              //   formatDate(
                              //     Timestamp.fromDate(
                              //         DateTime.parse(budgetData['expected_date'])),
                              //   ),
                              // ),
                              if (budgetData['date'] != null &&
                                  DateTime.tryParse(budgetData['date']) != null)
                                buildListTile(
                                  "Start Date",
                                  formatDate(
                                    Timestamp.fromDate(
                                        DateTime.parse(budgetData['date'])),
                                  ),
                                ),
                              if (budgetData['expected_date'] != null &&
                                  DateTime.tryParse(
                                          budgetData['expected_date']) !=
                                      null)
                                buildListTile(
                                  "End Date",
                                  formatDate(
                                    Timestamp.fromDate(DateTime.parse(
                                        budgetData['expected_date'])),
                                  ),
                                ),

                              // buildListTile("Start Date",
                              //     formatDate(budgetData['date'] as Timestamp)),
                              // buildListTile(
                              //     "End Date",
                              //     formatDate(budgetData['expected_date']
                              //         as Timestamp)),
                              SizedBox(height: 10),
                              buildButtons(
                                  context, budget.id, state.users[index].id),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  ListTile buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  Widget buildButtons(BuildContext context, String budgetId, String userId) {
    final cubit = context.read<AdminRequestsCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            cubit.approveBudget(userId, budgetId);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(150, 40),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Approve",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showRejectDialog(context, budgetId, userId, cubit);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(150, 40),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Reject",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Future<void> showRejectDialog(BuildContext context, String budgetId,
      String userId, AdminRequestsCubit cubit) async {
    TextEditingController reasonController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Reject"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure you want to reject this request?"),
              TextFormField(
                onChanged: (value) => reasonController.text = value,
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: "Reason",
                  hintText: "Enter the reason for rejection",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                String reason = reasonController.text;
                if (reason.isNotEmpty) {
                  cubit.rejectBudget(userId, budgetId, reason);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Send",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }
}
