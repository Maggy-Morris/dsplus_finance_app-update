import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/widgets/fullscreenImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'finacial_custody_cubit.dart';
import 'finacial_custody_state.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> budgetData;

  OrderDetailsScreen({required this.userData, required this.budgetData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderDetailsCubit(userData: userData, budgetData: budgetData),
      child: OrderDetailsView(
          userData: userData,
          budgetData: budgetData), // Pass userData to OrderDetailsView
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  final Map<String, dynamic> userData; // Define userData here
  OrderDetailsView(
      {required this.userData,
      required Map<String, dynamic>
          budgetData}); // Initialize userData in the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          if (state is OrderDetailsInitial) {
            return OrderDetailsBody(
                userData: userData); // Pass userData to OrderDetailsBody
          } else if (state is OrderDetailsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailsError) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////
///
class OrderDetailsBody extends StatelessWidget {
  final Map<String, dynamic> userData;

  OrderDetailsBody({required this.userData});

  final TextEditingController _discountAmountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Name: ${context.read<OrderDetailsCubit>().userData['name']}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Budget Name: ${context.read<OrderDetailsCubit>().budgetData['name']}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Amount: ${context.read<OrderDetailsCubit>().budgetData['amount']}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Budget Type: ${context.read<OrderDetailsCubit>().budgetData['type']}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Status: ${context.read<OrderDetailsCubit>().budgetData['status']}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 20),
            if (context.read<OrderDetailsCubit>().budgetData['status'] ==
                    'Approved' &&
                context.read<OrderDetailsCubit>().budgetData['type'] ==
                    'عهدة') ...[
              Text(
                "Settlement Amount:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                onFieldSubmitted: (value) {
                  final double discountAmount = double.tryParse(value) ?? 0;

                  context
                      .read<OrderDetailsCubit>()
                      .applyDiscount(discountAmount);
                },
                controller: _discountAmountController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter Settlement amount",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final double discountAmount =
                        double.tryParse(_discountAmountController.text) ?? 0;
                    context
                        .read<OrderDetailsCubit>()
                        .applyDiscount(discountAmount);
                  },
                  child: Text("Apply Settlement"),
                ),
              ),
              SizedBox(height: 20),
              if (context.select(
                      (OrderDetailsCubit cubit) => cubit.updatedAmount) !=
                  null)
                Text(
                  "Updated Amount: ${context.select((OrderDetailsCubit cubit) => cubit.updatedAmount)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

              ////////////////////////////////////
              /////////////////////////////////////
              ////////////////////////////////////

              // Fetch attachments for this transaction
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userData['id'] as String)
                    .collection('transactions')
                    .doc(context.read<OrderDetailsCubit>().budgetData['id'])
                    .collection('attachments')
                    .snapshots(),
                builder: (context, attachmentsSnapshot) {
                  if (attachmentsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final attachmentsDocs = attachmentsSnapshot.data?.docs ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: attachmentsDocs
                        .map((attachmentDoc) {
                          final attachmentData =
                              attachmentDoc.data() as Map<String, dynamic>? ??
                                  {};
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenImage(
                                          imageUrl: attachmentData['imageUrl']
                                              as String,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    attachmentData['imageUrl'] as String,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Attachment Amount: ${attachmentData['amount']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Attachment Description: ${attachmentData['description']}',
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        final attachmentData = (attachmentDoc
                                                .data()
                                            as Map<String, dynamic>)['amount'];
                                        final double discountAmount =
                                            (double.tryParse(attachmentData
                                                    .toString()) ??
                                                0);
                                        context
                                            .read<OrderDetailsCubit>()
                                            .applyDiscount(discountAmount);
                                      },
                                      child: Text("Approve"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add your rejection logic here
                                      },
                                      child: Text("Reject"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })
                        .toList()
                        .cast<Widget>(),
                  );
                },
              ),

              // StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('users')
              //       .doc(userData['userId'] as String)
              //       .collection('transactions')
              //       .doc(context.read<OrderDetailsCubit>().budgetData['id'])
              //       .collection('attachments')
              //       .snapshots(),
              //   builder: (context, attachmentsSnapshot) {
              //     if (attachmentsSnapshot.connectionState ==
              //         ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }
              //     final attachmentsDocs = attachmentsSnapshot.data?.docs ?? [];

              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: attachmentsDocs
              //           .map((attachmentDoc) {
              //             final attachmentData = attachmentDoc.data() ?? {};
              //             return Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 SizedBox(height: 10),
              //                 GestureDetector(
              //                   onTap: () {
              //                     Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                           builder: (context) => FullScreenImage(
              //                             imageUrl: (attachmentData as Map<
              //                                 String,
              //                                 dynamic>)['imageUrl'] as String,
              //                           ),
              //                         ));
              //                   },
              //                   child: Image.network(
              //                     (attachmentData
              //                             as Map<String, dynamic>)['imageUrl']
              //                         as String,
              //                     width: 100,
              //                     height: 100,
              //                   ),
              //                 ),

              //                 SizedBox(height: 10),
              //                   Text(
              //                     'Settlement Amount: ${(attachmentData as Map<String, dynamic>)['amount']}',
              //                     style: TextStyle(fontWeight: FontWeight.bold),
              //                   ),
              //                   Text(
              //                     'Settlement Description: ${attachmentData['description']}',
              //                   ),
              //                   SizedBox(height: 10),

              //               ],
              //             );
              //           })
              //           .toList()
              //           .cast<Widget>(),
              //     );
              //   },
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
