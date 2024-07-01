import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/financial_custody/cubit/finacial_custody_cubit.dart';
import 'package:dsplus_finance/admin/financial_custody/cubit/finacial_custody_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dsplus_finance/admin/requests/model/request_model.dart';
import 'package:dsplus_finance/widgets/fullscreenImage.dart';

import '../history/bloc/history_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  final RequestModel userData;

  OrderDetailsScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrderHistoryCubit()),
        BlocProvider(create: (context) => FinancialAttachmentCubit()),
      ],
      // create: (context) => FinancialAttachmentCubit(),
      child: OrderDetailsView(userData: userData),
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  final RequestModel userData;

  OrderDetailsView({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: OrderDetailsBody(userData: userData),
    );
  }
}

class OrderDetailsBody extends StatelessWidget {
  final RequestModel userData;

  OrderDetailsBody({required this.userData});

  @override
  Widget build(BuildContext context) {
    context
        .read<FinancialAttachmentCubit>()
        .fetchTransactionsAttachments(docId: userData.docId);
    context.read<FinancialAttachmentCubit>().getAmount(docId: userData.docId);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FinancialAttachmentCubit, FinancialAttachmentState>(
          builder: (context, state) {
            if (state.status == FinancialAttachmentStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == FinancialAttachmentStatus.error) {
              return Center(child: Text(state.error));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User Name: ${userData.userName}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 10),
                Text("Budget Name: ${userData.budgetName}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 10),
                Text("Amount: ${state.currentAmount ?? ''}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 10),
                Text("Budget Type: ${userData.type}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 10),
                Text("Status: ${userData.status}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 20),
                if (userData.status == 'Approved' &&
                    userData.type == 'عهدة'&& userData.attachments.isNotEmpty) ...[
                  Text("Settlement Amount:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  BlocBuilder<FinancialAttachmentCubit,
                      FinancialAttachmentState>(
                    builder: (context, state) {
                      if (state.status == FinancialAttachmentStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state.status ==
                          FinancialAttachmentStatus.error) {
                        return Center(child: Text(state.error));
                      }
                      if (state.status == FinancialAttachmentStatus.loaded) {
                        final attachments = state.attachments;
                        return Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.attachments?.length ?? 0,
                              itemBuilder: (context, index) => Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenImage(
                                              imageUrl: attachments?[index]
                                                      .imageUrl ??
                                                  "",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        attachments?[index].imageUrl ?? "",
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        'Amount: ${attachments?[index].amount ?? ""}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                          'Description: ${attachments?[index].description ?? ""}'),
                                    ),
                                    SizedBox(height: 10),
                                    (attachments?[index].status == "pending")
                                        ? Text(
                                            'Status: ${attachments?[index].status ?? ""}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                        : Container(),
                                    SizedBox(height: 10),
                                    Text(
                                        'Date: ${factorDate(attachments?[index].createdAt)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    (attachments?[index].status == "pending")
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  context
                                                      .read<
                                                          FinancialAttachmentCubit>()
                                                      .applyDiscount(
                                                        docId: userData.docId,
                                                        currentAmount:
                                                            state.currentAmount,
                                                        discountAmount:
                                                            attachments?[index]
                                                                    .amount ??
                                                                0.0,
                                                      );
                                                  context
                                                      .read<
                                                          FinancialAttachmentCubit>()
                                                      .approveBudget(
                                                          docId: userData.docId,
                                                          attId: attachments?[
                                                                      index]
                                                                  .transactionId ??
                                                              "");
                                                  context
                                                      .read<
                                                          FinancialAttachmentCubit>()
                                                      .fetchTransactionsAttachments(
                                                          docId:
                                                              userData.docId);
                                                  context
                                                      .read<
                                                          FinancialAttachmentCubit>()
                                                      .getAmount(
                                                          docId:
                                                              userData.docId);
                                                },
                                                child: Text("Approve"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showRejectDialog(
                                                      context,
                                                      userData.docId,
                                                      attachments![index]
                                                          .transactionId,
                                                      context.read<
                                                          FinancialAttachmentCubit>(),
                                                      attachments[index]
                                                          .transactionId);
                                                },
                                                child: Text("Reject"),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            attachments?[index].status ?? "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                    SizedBox(height: 10),
                                    (attachments?[index].status == "Rejected")
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Reason: ${attachments?[index].reason ?? ""}',
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(child: SizedBox.shrink());
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  factorDate(Timestamp? date) {
    if (date == null) {
      return "";
    }
    return date.toDate().toString().substring(0, 16);
  }

  Future<void> showRejectDialog(BuildContext context, String budgetId,
      String attId, FinancialAttachmentCubit cubit, String attatachment) async {
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
              onPressed: () async {
                await cubit.rejectBudget(
                  docId: budgetId,
                  attId: attId,
                  reason: reasonController.text,
                );
                cubit.fetchTransactionsAttachments(docId: userData.docId);
                Navigator.pop(context);
              },
              child: Text(
                "Reject",
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
}
