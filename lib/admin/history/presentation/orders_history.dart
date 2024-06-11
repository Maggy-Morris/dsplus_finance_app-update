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

    // Filter the users based on the selected filter
    List<RequestModel> filteredUsers = users;
    if (selectedFilter != 'All') {
      filteredUsers = users.where((user) => user.status == selectedFilter).toList();
    }

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
                  context.read<OrderHistoryCubit>().applySelectedFilter(newValue!);
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
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
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
                    buildListTile("User Email", user.email ?? ""),
                    buildListTile("Budget Name", user.name ?? ''),
                    buildListTile("Amount", "${user.amount ?? 0}"),
                    buildListTile("Budget Type", user.type ?? ''),
                    (user.cashOrCredit == false)
                        ? buildListTile("Payment Method", "Credit")
                        : buildListTile("Payment Method", "Cash"),
                    (user.cashOrCredit == false)
                        ? buildListTile("Bank Name", user.bankName ?? '')
                        : Container(),
                    (user.cashOrCredit == false)
                        ? buildListTile("Account Number", "${user.accountNumber ?? 0}")
                        : Container(),
                    buildListTile("Status", user.status ?? ''),
                    buildListTile("Start Date", user.date ?? ''),
                    (user.type == "اذن صرف")
                        ? buildListTile("End Date", user.expected_date ?? '')
                        : Container(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
