import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/fullscreenImage.dart';
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


class OrderHistoryBody extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
      builder: (context, state) {

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
                    value: state.selectedFilter,
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
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      state.hasMoreData &&
                      state.status != OrderHistoryStateStatus.loading) {
                    context.read<OrderHistoryCubit>().fetchMoreData();
                  }
                  return false;
                },
                child: state.documents.isEmpty &&
                        state.status == OrderHistoryStateStatus.initial
                    ? const Center(child: Text("Empty list"))
                    : ListView.builder(
                        itemCount: state.documents.length +
                            (state.hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.documents.length) {
                            return const Padding(
                              padding: EdgeInsets.all(13.0),
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
                                  buildListTile(
                                      "User Name", user.userName ?? ""),
                                  buildListTile(
                                      "Budget Name", user.budgetName ?? ''),
                                  buildListTile(
                                      "Amount", "${user.amount ?? 0}"),
                                  buildListTile("Budget Type", user.type ?? ''),
                                  user.cashOrCredit == false
                                      ? buildListTile(
                                          "Payment Method", "Credit")
                                      : buildListTile("Payment Method", "Cash"),
                                  if (user.cashOrCredit == false)
                                    buildListTile(
                                        "Bank Name", user.bankName ?? ''),
                                  if (user.cashOrCredit == false)
                                    buildListTile("Account Number",
                                        "${user.accountNumber ?? 0}"),
                                  buildListTile("Status", user.status ?? ''),
                                  buildListTile("Start Date", user.date ?? ''),
                                  if (user.type == "عهدة")
                                    buildListTile(
                                        "End Date", user.expected_date ?? ''),
                                  SizedBox(height: 10),
                                  (user.type == "اذن صرف")
                                      ? SizedBox(
                                        height: 100,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImageList(
                                                  imageUrlList: user
                                                      .attachments
                                                      .cast<String>(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: ListView(
                                            scrollDirection:
                                                Axis.horizontal,
                                            children: [
                                              for (var attachment
                                                  in user.attachments)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration:
                                                        BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .black
                                                              .withOpacity(
                                                                  0.1),
                                                          blurRadius: 5,
                                                          offset:
                                                              Offset(0, 5),
                                                        ),
                                                      ],
                                                      border: Border.all(
                                                          color:
                                                              Colors.grey,
                                                          width: 1),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8),
                                                      child: Image.network(
                                                        attachment,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      )
                                      : Container(),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
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
