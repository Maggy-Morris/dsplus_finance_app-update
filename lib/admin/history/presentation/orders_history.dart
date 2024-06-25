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
      create: (context) => OrderHistoryCubit(),
      child: OrderHistoryView(),
    );
  }
}

class OrderHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<OrderHistoryCubit>().fetchMoreData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History"),
        centerTitle: true,
      ),
      body: OrderHistoryBody(),
    );
  }
}


// class OrderHistoryBody extends StatelessWidget {
//   final List<RequestModel> users;
//   final String selectedFilter;
//   final String filter;
//
//   OrderHistoryBody({
//     required this.users,
//     required this.selectedFilter,
//     required this.filter,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat('dd/MM/yyyy');
//
//     // Filter the users based on the selected filter
//     List<RequestModel> filteredUsers = users;
//     if (selectedFilter != 'All') {
//       filteredUsers =
//           users.where((user) => user.status == selectedFilter).toList();
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Filter By:",
//                 style: TextStyle(fontSize: 20),
//               ),
//               SizedBox(width: 10),
//               DropdownButton<String>(
//                 value: selectedFilter,
//                 onChanged: (String? newValue) {
//                   context
//                       .read<OrderHistoryCubit>()
//                       .applySelectedFilter(newValue!);
//                 },
//                 items: <String>['All', 'Approved', 'pending', 'Rejected']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
//             builder: (context, state) {
//               return NotificationListener<ScrollNotification>(
//                 onNotification: (ScrollNotification scrollInfo) {
//                   if (scrollInfo.metrics.pixels ==
//                           scrollInfo.metrics.maxScrollExtent &&
//                       state.hasMoreData) {
//                     context.read<OrderHistoryCubit>().fetchMoreData();
//                   }
//                   return false;
//                 },
//                 child: (!state.isLoading && state.orders.isEmpty)
//                     ? Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         itemCount:
//                             filteredUsers.length + (state.isLoading ? 1 : 0),
//                         itemBuilder: (context, index) {
//                           if (index == filteredUsers.length) {
//                             return Center(child: CircularProgressIndicator());
//                           }
//                           final user = filteredUsers[index];
//                           return InkWell(
//                             onTap: () {
//                               (user.type == "عهدة")
//                                   ? Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             OrderDetailsScreen(
//                                           userData: user,
//                                         ),
//                                       ),
//                                     )
//                                   : () {};
//                             },
//                             child: Card(
//                               color: Colors.grey[200],
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 side: BorderSide(color: Colors.grey),
//                               ),
//                               margin: EdgeInsets.all(10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   buildListTile("User Email", user.email ?? ""),
//                                   buildListTile(
//                                       "User Name", user.userName ?? ""),
//                                   buildListTile(
//                                       "Budget Name", user.budgetName ?? ''),
//                                   buildListTile(
//                                       "Amount", "${user.amount ?? 0}"),
//                                   buildListTile("Budget Type", user.type ?? ''),
//                                   (user.cashOrCredit == false)
//                                       ? buildListTile(
//                                           "Payment Method", "Credit")
//                                       : buildListTile("Payment Method", "Cash"),
//                                   (user.cashOrCredit == false)
//                                       ? buildListTile(
//                                           "Bank Name", user.bankName ?? '')
//                                       : Container(),
//                                   (user.cashOrCredit == false)
//                                       ? buildListTile("Account Number",
//                                           "${user.accountNumber ?? 0}")
//                                       : Container(),
//                                   buildListTile("Status", user.status ?? ''),
//                                   buildListTile("Start Date", user.date ?? ''),
//                                   (user.type == "اذن صرف")
//                                       ? buildListTile(
//                                           "End Date", user.expected_date ?? '')
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   ListTile buildListTile(String title, String subtitle) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: SelectableText(
//         subtitle,
//         style: TextStyle(fontSize: 17),
//       ),
//     );
//   }
// }

class OrderHistoryBo extends StatefulWidget {
  const OrderHistoryBo({super.key, required this.users});

  final List<RequestModel> users;

  @override
  State<OrderHistoryBo> createState() => _OrderHistoryBoState();
}

class _OrderHistoryBoState extends State<OrderHistoryBo> {
  final int _limit = 3;

  DocumentSnapshot? _lastDocument;

  bool _isLoading = false;

  bool _hasMoreData = true;

  final List<DocumentSnapshot> _documents = [];

  @override
  void initState() {
    super.initState();
    _fetchMoreData();
  }

  void _fetchMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    /// TODO: Change collection by collection name
    Query query =
        FirebaseFirestore.instance.collection("transactions").limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _lastDocument = snapshot.docs.last;
        _documents.addAll(snapshot.docs);
        _isLoading = false;
        if (snapshot.docs.length < _limit) {
          _hasMoreData = false;
        }
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            _hasMoreData) {
          _fetchMoreData();
        }
        return false;
      },
      child: _documents.isEmpty && !_isLoading
          ? const Center(child: Text("Empty list"))
          : ListView.builder(
              itemCount: _documents.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _documents.length) {
                  return const LinearProgressIndicator();
                }
                final document = _documents[index];
                final data = document.data() as Map<String, dynamic>;
                RequestModel user = RequestModel.fromMap(data);

                /// TODO: Add data card here
                return InkWell(
                  onTap: () {
                    (user.type == "عهدة")
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(
                                userData: user,
                              ),
                            ),
                          )
                        : () {};
                  },
                  child: Card(
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
                        buildListTile("User Name", user.userName ?? ""),
                        buildListTile("Budget Name", user.budgetName ?? ''),
                        buildListTile("Amount", "${user.amount ?? 0}"),
                        buildListTile("Budget Type", user.type ?? ''),
                        (user.cashOrCredit == false)
                            ? buildListTile("Payment Method", "Credit")
                            : buildListTile("Payment Method", "Cash"),
                        (user.cashOrCredit == false)
                            ? buildListTile("Bank Name", user.bankName ?? '')
                            : Container(),
                        (user.cashOrCredit == false)
                            ? buildListTile(
                                "Account Number", "${user.accountNumber ?? 0}")
                            : Container(),
                        buildListTile("Status", user.status ?? ''),
                        buildListTile("Start Date", user.date ?? ''),
                        (user.type == "اذن صرف")
                            ? buildListTile(
                                "End Date", user.expected_date ?? '')
                            : Container(),
                      ],
                    ),
                  ),
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
      subtitle: SelectableText(
        subtitle,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}

///////////////////////////////

class OrderHistoryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
      builder: (context, state) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                state.hasMoreData &&
                state.status != OrderHistoryStateStatus.loading) {
              context.read<OrderHistoryCubit>().fetchMoreData();
            }
            return false;
          },
          child: state.documents.isEmpty && state.status == OrderHistoryStateStatus.initial
              ? const Center(child: Text("Empty list"))
              : ListView.builder(
            itemCount: state.documents.length + (state.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.documents.length) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final document = state.documents[index];
              final data = document.data() as Map<String, dynamic>;
              RequestModel user = RequestModel.fromMap(data);
              return InkWell(
                onTap: () {
                  if (user.type == "عهدة") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          userData: user,
                        ),
                      ),
                    );
                  }
                },
                child: Card(
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
                      buildListTile("User Name", user.userName ?? ""),
                      buildListTile("Budget Name", user.budgetName ?? ''),
                      buildListTile("Amount", "${user.amount ?? 0}"),
                      buildListTile("Budget Type", user.type ?? ''),
                      user.cashOrCredit == false
                          ? buildListTile("Payment Method", "Credit")
                          : buildListTile("Payment Method", "Cash"),
                      if (user.cashOrCredit == false)
                        buildListTile("Bank Name", user.bankName ?? ''),
                      if (user.cashOrCredit == false)
                        buildListTile("Account Number", "${user.accountNumber ?? 0}"),
                      buildListTile("Status", user.status ?? ''),
                      buildListTile("Start Date", user.date ?? ''),
                      if (user.type == "اذن صرف")
                        buildListTile("End Date", user.expected_date ?? ''),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  ListTile buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: SelectableText(
        subtitle,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
