import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../home_page/models/transactions_model.dart';
import 'bloc/transfer_bloc.dart';
import 'models/transfer_model.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:dsplus_finance/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

// ignore: must_be_immutable
class TransferScreen extends StatelessWidget {
  TransactionsModel transactionsModel = TransactionsModel();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Widget builder(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransferBloc>(
            create: (context) => TransferBloc()..add(TransferEvent()),
            child: TransferScreen()),
      ],
      child: TransferScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();

    return BlocBuilder<TransferBloc, TransferState>(builder: (context, state) {
      return SafeArea(
          child: GestureDetector(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
              height: getVerticalSize(50),
              leadingWidth: 59,
              leading: AppbarIconbutton(
                  svgPath: ImageConstant.imgArrowleftBlack900,
                  margin: getMargin(left: 24, top: 8, bottom: 7),
                  onTap: () {
                    Navigator.pushNamed(
                      context, '/home_page',
                      // Pass the transaction object as an argument
                    );
                  }),
              centerTitle: true,
              title: AppbarSubtitle(text: "عهدة".tr),
              // actions: [
              //   AppbarIconbutton(
              //       svgPath: ImageConstant.imgVolumeBlack900,
              //       margin: getMargin(left: 24, top: 7, right: 24, bottom: 8))
              // ]
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: getPadding(top: 30, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: getPadding(top: 12),
                        child: Text("lbl_alex_dordan".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsMedium18)),
                    Padding(
                        padding: getPadding(top: 1),
                        child: Text("lbl_web_developer".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsMedium10Gray500)),
                    Container(
                        width: getHorizontalSize(325),
                        margin: getMargin(left: 25, top: 28, right: 25),
                        padding: getPadding(
                            left: 44, top: 49, right: 44, bottom: 49),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: fs.Svg(ImageConstant.imgGroup199),
                                fit: BoxFit.cover)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageView(
                                  svgPath: ImageConstant.imgVolume23x36,
                                  height: getVerticalSize(23),
                                  width: getHorizontalSize(36),
                                  margin: getMargin(bottom: 18)),
                              CustomImageView(
                                  svgPath: ImageConstant.img1,
                                  height: getVerticalSize(4),
                                  width: getHorizontalSize(32),
                                  margin:
                                      getMargin(left: 20, top: 10, bottom: 27)),
                              CustomImageView(
                                  svgPath: ImageConstant.img1,
                                  height: getVerticalSize(4),
                                  width: getHorizontalSize(32),
                                  margin:
                                      getMargin(left: 10, top: 10, bottom: 27)),
                              Padding(
                                  padding:
                                      getPadding(left: 10, top: 3, bottom: 23),
                                  child: Text("lbl_4023".tr,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtPoppinsMedium10)),
                              Padding(
                                  padding: getPadding(
                                      left: 8, top: 3, right: 38, bottom: 23),
                                  child: Text("lbl_5534".tr,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtPoppinsMedium10))
                            ])),
                    TextFormField(
                      focusNode: FocusNode(),
                      onChanged: (value) {
                        TransferBloc.get(context).add(EditName(name: value));
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Name',
                      ),
                      onSaved: (String? value) {},
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      // focusNode: FocusNode(),

                      onChanged: (value) {
                        TransferBloc.get(context).add(
                            EditAmount(amount: double.tryParse(value) ?? 0.0));
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.monetization_on_sharp),
                        hintText: 'Money',
                        labelText: 'Money',
                      ),
                      // onSaved: (String? value) {
                      //   // This optional block of code can be used to run
                      //   // code when the user saves the form.
                      // },

                      // inputFormatters: ,

                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: state.startDateString),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.date_range_outlined),
                        labelText: 'Start Date(dd/mm/yyyy)',
                      ),
                      keyboardType: TextInputType.datetime,
                      readOnly:
                          true, // Make the field read-only to prevent keyboard input
                      onTap: () async {
                        // Show date picker when the field is tapped
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          TransferBloc.get(context).add(EditStartDateString(
                              startDateString:
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"));
                          // String formattedDate =
                          //     "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          TransferBloc.get(context)
                              .add(EditStartDate(startDate: pickedDate));

                          // startDateController?.text =
                          //     formattedDate; // Set the date in the controller
                        }
                      },
                    ),
                    TextFormField(
                      focusNode: FocusNode(),
                      controller:
                          TextEditingController(text: state.expectedDateString),
                      // onChanged: (value) {
                      //   transactionsModel.expectedDate = value;
                      // },
                      readOnly: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.date_range_outlined),
                        labelText: 'Expected Date(dd/mm/yyyy)',
                      ),
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        // Show date picker when the field is tapped
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          TransferBloc.get(context).add(ExpectedDateString(
                              expectedDateString:
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"));
                          TransferBloc.get(context)
                              .add(ExpectedDate(expectedDate: pickedDate));
                          // String formattedDate =
                          //     "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          // extractedtDateController?.text =
                          //     formattedDate; // Set the date in the controller
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile(
                            title: const Text('Cash'),
                            value: 'cash',
                            groupValue: state.selectedOption,
                            onChanged: (value) {
                              context.read<TransferBloc>().add(
                                  RadioButtonChanged(
                                      selectedOption: value ?? "",
                                      showTextField: false));
                            },
                          ),
                          RadioListTile(
                            title: const Text('Credit'),
                            value: 'credit',
                            groupValue: state.selectedOption,
                            onChanged: (value) {
                              context.read<TransferBloc>().add(
                                  RadioButtonChanged(
                                      selectedOption: value ?? "",
                                      showTextField: true));
                            },
                          ),
                          if (state.showTextField == true)
                            Column(
                              children: [
                                TextFormField(
                                  onChanged: (value) {
                                    TransferBloc.get(context).add(AccountNumber(
                                        accountNumber: int.parse(value)));
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Enter Account Number'),
                                  keyboardType: TextInputType.number,
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    TransferBloc.get(context)
                                        .add(BankName(bankName: value));
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Enter Bank Name'),
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    CustomIconButton(
                      height: 70,
                      width: 70,
                      margin: getMargin(top: 40, bottom: 5),
                      variant: IconButtonVariant.OutlineBlueA70066,
                      shape: IconButtonShape.CircleBorder35,
                      padding: IconButtonPadding.PaddingAll23,
                      onTap: () async {
                        if (
                          state.name?.isNotEmpty == true &&
                            state.amount != 0 &&
                            state.startDateString?.isNotEmpty == true &&
                            state.expectedDateString?.isNotEmpty == true) {
                          TransactionsModel transaction = TransactionsModel(
                            email: firebaseAuth.currentUser?.email ?? "",
                            name: state.name,
                            amount: state.amount,
                            userId: firebaseAuth.currentUser?.uid,
                            type: 'عهدة',
                            status: 'pending',
                            date: state.startDateString,
                            expectedDate: state.expectedDateString,
                            id: "",
                            cashOrCredit:
                                state.selectedOption == "cash" ? true : false,
                            bankName: state.bankName ,
                            accountNumber: state.accountNumber,
                          );

                          onTapBtnArrowright(context, transaction);
                        } else {
                          // Show a snackbar or any other UI feedback indicating that all fields are required
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all fields.'),
                            ),
                          );
                        }
                      },
                      child:
                          CustomImageView(svgPath: ImageConstant.imgArrowright),
                    ),
                  ],
                ),
              ),
            )),
      ));
    });
  }

  void onTapBtnArrowright(BuildContext context, TransactionsModel transaction) {
    NavigatorService.pushNamed(
      AppRoutes.sendMoneyScreen,
      arguments: transaction, // Pass the transaction object as an argument
    );
  }

  onTapArrowleft(BuildContext context) {
    NavigatorService.goBack();
  }
}

onTapBtnArrowrightaftersubmittngrrequest(BuildContext context) {
  NavigatorService.pushNamed(
    AppRoutes.homePage,
  );
}
