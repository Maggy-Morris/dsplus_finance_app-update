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
          if (state is OrderHistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderHistoryLoaded) {
            return OrderHistoryBody(
              users: state.users,
              selectedFilter: state.selectedFilter,
              filter: state.filter,
              searchController: state.searchController,
            );
          } else if (state is OrderHistoryError) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}

class OrderHistoryBody extends StatelessWidget {
  final List<DocumentSnapshot> users;
  final String selectedFilter;
  final String filter;
  final TextEditingController searchController;

  OrderHistoryBody({
    required this.users,
    required this.selectedFilter,
    required this.filter,
    required this.searchController,
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: TextField(
        //     keyboardType: TextInputType.text,
        //     controller: searchController,
        //     decoration: InputDecoration(
        //       labelText: 'Search',
        //       suffixIcon: IconButton(
        //         onPressed: () {
        //           context.read<OrderHistoryCubit>().clearSearch();
        //         },
        //         icon: Icon(Icons.clear),
        //       ),
        //     ),
        //     onChanged: (query) {
        //       context.read<OrderHistoryCubit>().applyFilter(query);
        //     },
        //   ),
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(users[index].id)
                    .collection('transactions')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final budgets = snapshot.data!.docs;

                  final filteredBudgets = budgets.where((budget) {
                    final budgetData = budget.data() as Map<String, dynamic>;

                    if (selectedFilter != 'All' &&
                        budgetData['status'] != selectedFilter) {
                      return false;
                    }

                    if (filter.isNotEmpty &&
                        budgetData.values.any((value) => value
                            .toString()
                            .toLowerCase()
                            .contains(filter.toLowerCase()))) {
                      return true;
                    }

                    return true;
                  }).toList();

                  // formatDate(
                  //                 Timestamp.fromDate(
                  //                     DateTime.parse(budgetData['date'])),
                  //               ),

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...filteredBudgets.map((budget) {
                        final budgetData =
                            budget.data() as Map<String, dynamic>;
                        final startDate = dateFormat.parse(budgetData['date']);

                        // final expectedDateData =
                        //     budgetData['expected_date'] ?? '';
                        // final endDate = expectedDateData != null &&
                        //         DateTime.tryParse(expectedDateData) != null
                        //     ? dateFormat.parse(expectedDateData)
                        //     : null;
                        final endDate = dateFormat.parse(
                            budgetData['expected_date'] == null
                                ? budgetData['date']
                                : budgetData['expected_date']);
                        // ? dateFormat.parse(budgetData['date'])
                        // : dateFormat.parse(budgetData['expected_date']);

                        // final startDate = (budgetData['date'] ).toDate();
                        // final endDate = (budgetData['expected_date'] ).toDate();

                        return GestureDetector(
                          onTap: () {
                            if (budgetData['status'] == 'Approved' &&
                                budgetData['type'] == 'عهدة') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(
                                      userData: userData,
                                      budgetData: budgetData),
                                ),
                              );
                            }
                          },
                          child: buildBudgetCard(
                              userData, budgetData, startDate, endDate),
                        );
                      }).toList(),
                    ],
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
