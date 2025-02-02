import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ask_for_cash_screen/ask_for_cash_screen.dart';
import '../attachements/banner/screens/add_banner_screen.dart';
import '../attachements/constants/colors.dart';
import '../attachements/models/banner.dart' as model;
import 'package:dsplus_finance/presentation/attachements/banner/controllers/banner_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/navigator_service.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_bar/appbar_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../home_page/models/transactions_model.dart';
import 'bloc/settlements_of_accounts_bloc.dart';
import 'models/settlemetns_of_accounts_model.dart';

// ignore: must_be_immutable
class SettlementOfAccountsScreen extends StatelessWidget {
  TransactionsModel? homePageItemModelObj;
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final TransactionsModel homePageItemModelObj =
  //       ModalRoute.of(context)!.settings.arguments as TransactionsModel;
  SettlementOfAccountsScreen();
  static Widget builder(BuildContext context) {
    return BlocProvider<SettlementsOfAccountsBloc>(
        create: (context) => SettlementsOfAccountsBloc(
            SettlementsOfAccountsState(
                settlementsOfAccountsModelObj: SettlementsOfAccountsModel()))
          ..add(SettlementsOfAccountsEvent()),
        child: SettlementOfAccountsScreen());
  }

  BannerController bannerController = BannerController();

  @override
  Widget build(BuildContext context) {
    // to get the data from the previous screen
    final TransactionsModel homePageItemModelObj =
        ModalRoute.of(context)!.settings.arguments as TransactionsModel;
    ////////////////////////////////////////////
    return Scaffold(
      appBar: CustomAppBar(
        height: getVerticalSize(49),
        leadingWidth: 59,
        leading: AppbarIconbutton(
            svgPath: ImageConstant.imgArrowleftBlack900,
            margin: getMargin(left: 24, top: 7, bottom: 7),
            onTap: () {
              onTapArrowleft5(context);
            }),
        centerTitle: true,
        title: AppbarSubtitle(
            text:
                //  homePageItemModelObj?.type ??
                "تصفية"),
      ),
      body: ListView(padding: EdgeInsets.all(16.0), children: [
        // Center(child: Text(" ${}")),
        // SizedBox(
        //   height: 50,
        // ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Balance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '${homePageItemModelObj.amount}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Adjust color as needed
                ),
              ),
            ],
          ),
        ),

        ////////////////////////////////////////////////////
        // BlocSelector<SettlementsOfAccountsBloc, SettlementsOfAccountsState,
        //     TextEditingController?>(
        //   selector: (state) => state.descriptionController,
        //   builder: (context, descriptionController) {
        //     return TextFormField(
        //       focusNode: FocusNode(),
        //       controller: descriptionController,
        //       // onChanged: (value) {
        //       //   homePageItemModelObj.name = value;
        //       // },
        //       decoration: const InputDecoration(
        //         icon: Icon(Icons.person),
        //         labelText: 'Description',
        //       ),
        //       onSaved: (String? value) {},
        //       keyboardType: TextInputType.name,
        //     );
        //   },
        // ),
        // BlocSelector<SettlementsOfAccountsBloc, SettlementsOfAccountsState,
        //     TextEditingController?>(
        //   selector: (state) => state.amountController,
        //   builder: (context, amountController) {
        //     return TextFormField(
        //       focusNode: FocusNode(),
        //       controller: amountController,
        //       // onChanged: (value) {
        //       //   homePageItemModelObj.amount = value as double?;
        //       //   // double.tryParse(value);
        //       // },
        //       decoration: const InputDecoration(
        //         icon: Icon(Icons.monetization_on_sharp),
        //         hintText: 'Money',
        //         labelText: 'Money',
        //       ),

        //       keyboardType: TextInputType.number,
        //     );
        //   },
        // ),

        ////////////////////////////////////////////////////
        ///Add Attachemnts
        SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 20),
                const Text(
                  'Add Settlement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context, '/add-banner-screen',

                    //   //  transId: homePageItemModelObj.id ?? '',

                    // );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AddBannerScreen(
                    //       transId: homePageItemModelObj.id ?? '',
                    //     ),
                    //   ),
                    // );

                    NavigatorService.pushNamed(
                      AppRoutes.addBannerScreen,
                      arguments: homePageItemModelObj,
                    );
                    // Navigator.pushNamed(context, AddBannerScreen.routeName);
                  },
                  splashColor: scheme.primary.withOpacity(1),
                  child: Ink(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: scheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: scheme.primary,
                      size: 50,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                StreamBuilder<List<model.Banner>>(
                    stream: bannerController.fetchBanner(
                      transactionID: homePageItemModelObj.id ?? '',
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('loading');
                      }

                      return ListView.builder(
                          // scrollDirection: Axis.horizontal,

                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final banner = snapshot.data![index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(1, 3),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: banner.imageUrl),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 150,
                                          child: AspectRatio(
                                            aspectRatio: 4 / 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    banner.imageUrl,
                                                  ) as ImageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          });
                    }),
              ],
            ),
          ),
        ),

        /// the button of navigateion to the next screen
        CustomIconButton(
          height: 70,
          width: 70,
          margin: getMargin(top: 40, bottom: 5),
          variant: IconButtonVariant.OutlineBlueA70066,
          shape: IconButtonShape.CircleBorder35,
          padding: IconButtonPadding.PaddingAll23,

          //Check this out cause it ain't working properly
          onTap: () async {
            // final state = context.read<SettlementsOfAccountsBloc>().state;

            // if (state.descriptionController?.text.isNotEmpty == true &&
            //     state.amountController?.text.isNotEmpty == true) {
            //   final name = state.descriptionController?.text ?? '';
            //   final amount = double.parse(state.amountController?.text ?? '');

            //   if (amount > (homePageItemModelObj.amount ?? 0)) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         backgroundColor: Colors.red,
            //         content: Text(
            //             'You cannot ask for more money than your balance.'),
            //       ),
            //     );
            //   } else {
            //     // addTransactionToFirebase(
            //     //   name,
            //     //   amount,
            //     //   homePageItemModelObj.id ?? '', // Pass the transaction ID
            //     // );

            //     NavigatorService.pushNamedAndRemoveUntil(
            //       AppRoutes.homePageContainerScreen,
            //       arguments:
            //           homePageItemModelObj, // Pass the transaction object as an argument
            //     );
            //   }
            // } else {
            //   // Show a snackbar or any other UI feedback indicating that all fields are required
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       backgroundColor: Colors.red,
            //       content: Text('Please fill all fields.'),
            //     ),
            //   );
            // }
            NavigatorService.pushNamedAndRemoveUntil(
              AppRoutes.homePageContainerScreen,
              arguments:
                  homePageItemModelObj, // Pass the transaction object as an argument
            );
          },
          child: CustomImageView(svgPath: ImageConstant.imgArrowright),
        ),
      ]),
    );
  }

  // void addTransactionToFirebase(
  //   String description,
  //   double amount,
  //   String transactionID, // Pass the transaction ID
  // ) async {
  //   try {
  //     String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     // Get the document reference for the user's transaction with the provided ID
  //     var transactionRef = firestore
  //         .collection('users')
  //         .doc(userID)
  //         .collection('transactions')
  //         .doc(transactionID)
  //         .collection('settlements');

  //     // Create a reference to the settlements subcollection inside the transaction document
  //     // var settlementsCollectionRef = transactionRef.collection('settlements');

  //     // Add the data to the settlements subcollection
  //     await transactionRef.add({
  //       'description': description,
  //       'amount': amount,
  //       // Add other fields as needed
  //     });

  //     print('Settlement added successfully to Firebase!');
  //   } catch (error, stackTrace) {
  //     print('Error adding settlement to Firebase: $error');
  //     print(stackTrace);
  //     // Handle error
  //   }
  // }

  onTapArrowleft5(BuildContext context) {
    NavigatorService.goBack();
  }

  onTapBtnArrowright(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.sendMoneyScreen,
    );
  }
}
