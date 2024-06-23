import 'package:dsplus_finance/admin/requests/cubit/requests_cubit.dart';
import 'package:dsplus_finance/admin/requests/cubit/requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminRequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AdminRequestsCubit>().fetchData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
        builder: (context, state) {
          if (state.requests == null) {
            return Center(child: Text("No requests found"));
          }
          if (state.status == AdminRequestsStatus.loaded) {
            if (state.requests!.isEmpty) {
              return Center(child: Text("No requests found"));
            }
            return ListView.builder(
              itemCount: state.requests?.length,
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
                          "User Email", state.requests?[index].email ?? ""),
                      buildListTile(
                          "User Name", state.requests?[index].userName ?? ""),
                      buildListTile(
                          "Budget Name", state.requests?[index].budgetName ?? ''),
                      buildListTile(
                          "Amount", "${state.requests?[index].amount ?? 0}"),
                      buildListTile(
                          "Budget Type", state.requests?[index].type ?? ''),
                      (state.requests?[index].cashOrCredit == false)
                          ? buildListTile("Payment Method", "Credit")
                          : buildListTile("Payment Method", "Cash"),
                      (state.requests?[index].cashOrCredit == false)
                          ? buildListTile("Bank Name",
                              state.requests?[index].bankName ?? '')
                          : Container(),
                      (state.requests?[index].cashOrCredit == false)
                          ? buildListTile("Account Number",
                              "${state.requests?[index].accountNumber ?? 0}")
                          : Container(),
                      buildListTile(
                          "Status", state.requests?[index].status ?? ''),
                      buildListTile(
                          "Start Date", state.requests?[index].date ?? ''),
                      (state.requests?[index].type == "اذن صرف")
                          ? buildListTile("End Date",
                              state.requests?[index].expected_date ?? '')
                          : Container(),
                      SizedBox(height: 10),
                      buildButtons(context, state.requests?[index].docId ?? "",
                          state.requests?[index].userId ?? ""),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

buildListTile(String title, String subtitle) {
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
        onPressed: () {
          cubit.approveBudget(budgetId);
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
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () async{
              String reason = reasonController.text;
              if (reason.isNotEmpty) {
                await cubit.rejectBudget(budgetId, reason);
                // cubit.rejectBudget2(userId, budgetId, reason);
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
