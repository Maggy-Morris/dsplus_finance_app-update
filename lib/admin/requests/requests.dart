import 'package:dsplus_finance/admin/requests/cubit/requests_cubit.dart';
import 'package:dsplus_finance/admin/requests/cubit/requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminRequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AdminRequestsCubit>().fetchMoreData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Requests"),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
        builder: (context, state) {
          if (state.status == AdminRequestsStatus.loaded &&
              state.requests.isEmpty || state.requests.isEmpty && state.status == AdminRequestsStatus.approved || state.requests.isEmpty && state.status == AdminRequestsStatus.rejected) {
            return const Center(child: Text("No requests found"));
          }
          if (state.status == AdminRequestsStatus.error) {
            return Center(child: Text("Error loading requests"));
          }
          if (state.status == AdminRequestsStatus.loading ) {
            context.read<AdminRequestsCubit>().fetchMoreData();
          }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                          state.hasMoreData &&
                          state.status != AdminRequestsStatus.loading) {
                        context.read<AdminRequestsCubit>().fetchMoreData();
                      }
                      return false;
                    },
                    child: state.requests.isEmpty &&
                        state.status == AdminRequestsStatus.initial
                        ? const Center(child: Text("Empty list"))
                        :
                    ListView.builder(
                      itemCount: state.requests.length +(state.hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.requests.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return buildRequestCard(context, state.requests[index]);
                      },
                    ),
                  ),
                ),
              ],
            );
          }

      ),
    );
  }

  Widget buildRequestCard(BuildContext context, dynamic request) {
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
          buildListTile("User Email", request.email ?? ""),
          buildListTile("User Name", request.userName ?? ""),
          buildListTile("Budget Name", request.budgetName ?? ''),
          buildListTile("Amount", "${request.amount ?? 0}"),
          buildListTile("Budget Type", request.type ?? ''),
          request.cashOrCredit == false
              ? buildListTile("Payment Method", "Credit")
              : buildListTile("Payment Method", "Cash"),
          request.cashOrCredit == false
              ? buildListTile("Bank Name", request.bankName ?? '')
              : Container(),
          request.cashOrCredit == false
              ? buildListTile("Account Number", "${request.accountNumber ?? 0}")
              : Container(),
          buildListTile("Status", request.status ?? ''),
          buildListTile("Start Date", request.date ?? ''),
          request.type == "اذن صرف"
              ? buildListTile("End Date", request.expected_date ?? '')
              : Container(),
          SizedBox(height: 10),
          buildButtons(context, request.docId ?? "", request.userId ?? ""),
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
      subtitle: SelectableText(
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
          onPressed: () async {
                        await
            cubit.approveBudget(budgetId);
                        await cubit.fetchMoreData();
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                String reason = reasonController.text;
                if (reason.isNotEmpty) {
                  await cubit.rejectBudget(budgetId, reason);
                  await cubit.fetchMoreData();
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Send",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
