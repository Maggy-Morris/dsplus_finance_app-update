import 'package:dsplus_finance/admin/requests/cubit/requests_cubit.dart';
import 'package:dsplus_finance/admin/requests/cubit/requests_state.dart';
import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:dsplus_finance/core/utils/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/fullscreenImage.dart';

class AdminRequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AdminRequestsCubit>().fetchMoreData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Pending Requests"),
          centerTitle: true,
          // backgroundColor: Colors.white,
          forceMaterialTransparency: true,
        ),
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state.status == UsersStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return (state.currentUserRole == "Admin" ||
                    state.currentUserRole == "SuperAdmin")
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
                        builder: (context, state) {
                          if (state.status == AdminRequestsStatus.loaded &&
                                  state.requests.isEmpty ||
                              state.requests.isEmpty &&
                                  state.status ==
                                      AdminRequestsStatus.approved ||
                              state.requests.isEmpty &&
                                  state.status ==
                                      AdminRequestsStatus.rejected) {
                            return const Center(
                                child: Text("No requests found"));
                          }
                          if (state.status == AdminRequestsStatus.error) {
                            return Center(
                                child: Text("Error loading requests"));
                          }
                          if (state.status == AdminRequestsStatus.loading) {
                            context.read<AdminRequestsCubit>().fetchMoreData();
                          }
                          return Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent &&
                                    state.hasMoreData &&
                                    state.status !=
                                        AdminRequestsStatus.loading) {
                                  context
                                      .read<AdminRequestsCubit>()
                                      .fetchMoreData();
                                }
                                return false;
                              },
                              child: ListView.builder(
                                itemCount: state.requests.length +
                                    (state.hasMoreData ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == state.requests.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                  return buildRequestCard(
                                      context, state.requests[index]);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("You are not authorized to view this page"),
                        ElevatedButton(
                          onPressed: () => logout(context),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
          },
        ));
  }

  Widget buildRequestCard(BuildContext context, dynamic request) {
    final ScrollController _scrollController = ScrollController();
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
          request.type == "عهدة"
              ? buildListTile("End Date", request.expected_date ?? '')
              : Container(),
          (request.type == "اذن صرف")
              ? Scrollbar(
                  radius: Radius.circular(10),
                  thickness: 5,
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SizedBox(
                    height: 100,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageList(
                              imageUrlList: request.attachments.cast<String>(),
                            ),
                          ),
                        );
                      },
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var attachment in request.attachments)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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
                  ),
                )
              : Container(),
          SizedBox(height: 10),
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
            await cubit.approveBudget(budgetId);
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
