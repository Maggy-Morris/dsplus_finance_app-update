import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../financial_custody/financial_custody_order_details.dart';
import '../bloc/history_cubit.dart';
import '../bloc/history_state.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryCubit()..fetchData(),
      child: OrderHistoryView(),
    );
  }
}

class OrderHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History"),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        builder: (context, state) {
          if (state.status == OrderHistoryStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == OrderHistoryStatus.loaded) {
            return OrderHistoryBody(
              users: state.orders,
              selectedFilter: state.selectedFilter,
              filter: state.filter,
            );
          } else if (state.status == OrderHistoryStatus.error) {
            return Center(child: Text(state.error));
          }
          return Container();
        },
      ),
    );
  }
}

class OrderHistoryBody extends StatelessWidget {
  final List<RequestModel> users;
  final String selectedFilter;
  final String filter;

  OrderHistoryBody({
    required this.users,
    required this.selectedFilter,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filter By:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedFilter,
                onChanged: (String? newValue) {
                  context
                      .read<OrderHistoryCubit>()
                      .applySelectedFilter(newValue!);
                },
                items: <String>['All', 'Approved', 'pending', 'Rejected']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[200],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey),
                    ),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildListTile(
                            "User Email", state.orders[index].email ?? ""),
                        buildListTile(
                            "Budget Name", state.orders[index].name ?? ''),
                        buildListTile(
                            "Amount", "${state.orders[index].amount ?? 0}"),
                        buildListTile(
                            "Budget Type", state.orders[index].type ?? ''),
                        (state.orders[index].cashOrCredit == false)
                            ? buildListTile("Payment Method", "Credit")
                            : buildListTile("Payment Method", "Cash"),
                        (state.orders[index].cashOrCredit == false)
                            ? buildListTile(
                                "Bank Name", state.orders[index].bankName ?? '')
                            : Container(),
                        (state.orders[index].cashOrCredit == false)
                            ? buildListTile("Account Number",
                                "${state.orders[index].accountNumber ?? 0}")
                            : Container(),
                        buildListTile(
                            "Status", state.orders[index].status ?? ''),
                        buildListTile(
                            "Start Date", state.orders?[index].date ?? ''),
                        (state.orders?[index].type == "اذن صرف")
                            ? buildListTile("End Date",
                                state.orders?[index].expected_date ?? '')
                            : Container(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildBudgetCard(Map<String, dynamic> userData,
      Map<String, dynamic> budgetData, DateTime startDate, DateTime endDate) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildListTile("User Name", userData['name'] ?? ''),
          buildListTile("Budget Name", budgetData['name'] ?? ''),
          buildListTile("Amount", budgetData['amount']?.toString() ?? ''),
          buildListTile("Budget Type", budgetData['type'] ?? ''),
          buildListTile("Status", budgetData['status'] ?? ''),
          buildListTile(
              "Start Date", DateFormat('dd/MM/yyyy').format(startDate)),
          endDate == startDate
              ? SizedBox()
              : buildListTile(
                  "End Date", DateFormat('dd/MM/yyyy').format(endDate)),
          if (budgetData['status'] ==
              'Rejected') // Show reason for rejected orders
            buildListTile("Reason for Rejection", budgetData['reason'] ?? ''),
          SizedBox(height: 10),
        ],
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
}
