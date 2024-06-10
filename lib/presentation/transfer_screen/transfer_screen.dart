import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../home_page/models/transactions_model.dart';
import '../radioButton/bloc/radio_button_bloc.dart';
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

  final RadioButtonBloc radioButtonBloc = RadioButtonBloc();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Widget builder(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransferBloc>(
            create: (context) => TransferBloc(
                TransferState(transferModelObj: TransferModel(), files: []))
              ..add(TransferEvent()),
            child: TransferScreen()),
        BlocProvider<RadioButtonBloc>(
          create: (BuildContext context) => RadioButtonBloc(),
        ),
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

                    BlocSelector<TransferBloc, TransferState,
                        TextEditingController?>(
                      selector: (state) => state.nameController,
                      builder: (context, nameController) {
                        return TextFormField(
                          focusNode: FocusNode(),
                          controller: nameController,
                          // onChanged: (value) {
                          //   transactionsModel.name = value;
                          // },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                          onSaved: (String? value) {},
                          keyboardType: TextInputType.name,
                        );
                      },
                    ),
                    BlocSelector<TransferBloc, TransferState,
                        TextEditingController?>(
                      selector: (state) => state.amountController,
                      builder: (context, amountController) {
                        return TextFormField(
                          focusNode: FocusNode(),

                          controller: amountController,
                          // onChanged: (value) {
                          //   transactionsModel.amount = value as double;
                          //   // double.tryParse(value);
                          // },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.monetization_on_sharp),
                            hintText: 'Money',
                            labelText: 'Money',
                          ),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },

                          // inputFormatters: ,

                          keyboardType: TextInputType.number,
                        );
                      },
                    ),
// onPressed: () {
//   context.read<TransferBloc>().add(SelectDateEvent());
// },
                    // BlocSelector<TransferBloc, TransferState, DateTime?>(
                    //   selector: (state) => state.startDate,
                    //   builder: (context, startDate) {
                    //     return TextFormField(
                    //       focusNode: FocusNode(),
                    //       // controller: startDateController,
                    //       // onChanged: (value) {
                    //       //   transactionsModel.date = value;
                    //       // },
                    //       decoration: const InputDecoration(
                    //         icon: Icon(Icons.date_range_outlined),
                    //         labelText: 'Start Date(2000-12-31)',
                    //       ),
                    //       onSaved: (String? value) {},
                    //       keyboardType: TextInputType.datetime,
                    //       readOnly: true, // Make the text field read-only
                    //       onTap: () async {
                    //         final DateTime? pickedDate = await showDatePicker(
                    //           context: context,
                    //           initialDate: startDate ?? DateTime.now(),
                    //           firstDate: DateTime(1900),
                    //           lastDate: DateTime(2100),
                    //         );
                    //         if (pickedDate != null) {
                    //           context.read<TransferBloc>().add(
                    //               TransferEvent.startDateChanged(pickedDate));
                    //         }
                    //       },
                    //     );
                    //   },
                    // ),

                    // BlocSelector<TransferBloc, TransferState, DateTime?>(
                    //   selector: (state) => state.expectedDate,
                    //   builder: (context, expectedDate) {
                    //     return TextFormField(
                    //       focusNode: FocusNode(),
                    //       // controller: extractedtDateController,
                    //       // onChanged: (value) {
                    //       //   transactionsModel.expectedDate = value;
                    //       // },
                    //       decoration: const InputDecoration(
                    //         icon: Icon(Icons.date_range_outlined),
                    //         labelText: 'Expected Date(2000-12-31)',
                    //       ),
                    //       onSaved: (String? value) {},
                    //       keyboardType: TextInputType.datetime,
                    //       readOnly: true, // Make the text field read-only
                    //       onTap: () async {
                    //         final DateTime? pickedDate = await showDatePicker(
                    //           context: context,
                    //           initialDate: expectedDate ?? DateTime.now(),
                    //           firstDate: DateTime(1900),
                    //           lastDate: DateTime(2100),
                    //         );
                    //         if (pickedDate != null) {
                    //           context.read<TransferBloc>().add(
                    //               TransferEvent.expectedDateChanged(
                    //                   pickedDate));
                    //         }
                    //       },
                    //     );
                    //   },
                    // ),

                    BlocSelector<TransferBloc, TransferState,
                        TextEditingController?>(
                      selector: (state) => state.startDateController,
                      builder: (context, startDateController) {
                        return TextFormField(
                          // inputFormatters: [DateInputFormatter()],

                          focusNode: FocusNode(),
                          controller: startDateController,
                          // onChanged: (value) {
                          //   transactionsModel.date = value;
                          // },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.date_range_outlined),
                            labelText: 'Start Date(dd/mm/yyyy)',
                          ),
                          onSaved: (String? value) {},
                          keyboardType: TextInputType.datetime,
                        );
                      },
                    ),

                    BlocSelector<TransferBloc, TransferState,
                        TextEditingController?>(
                      selector: (state) => state.extractedtDateController,
                      builder: (context, extractedtDateController) {
                        return TextFormField(
                          focusNode: FocusNode(),
                          controller: extractedtDateController,
                          // onChanged: (value) {
                          //   transactionsModel.expectedDate = value;
                          // },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.date_range_outlined),
                            labelText: 'Expected Date(dd/mm/yyyy)',
                          ),
                          onSaved: (String? value) {},
                          keyboardType: TextInputType.datetime,
                        );
                      },
                    ),
                    /////////////////////////////////////////////
                    //RadioButtonBlocProvider
                    BlocProvider(
                      create: (context) => radioButtonBloc,
                      child: BlocBuilder<RadioButtonBloc, RadioButtonState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  title: const Text('Cash'),
                                  value: 'cash',
                                  groupValue: state.selectedOption,
                                  onChanged: (value) {
                                    context.read<RadioButtonBloc>().add(
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
                                    context.read<RadioButtonBloc>().add(
                                        RadioButtonChanged(
                                            selectedOption: value ?? "",
                                            showTextField: true));
                                  },
                                ),
                                if (state.showTextField)
                                  Column(
                                    children: [
                                      BlocSelector<TransferBloc, TransferState,
                                          TextEditingController?>(
                                        selector: (state) =>
                                            state.accountNumberController,
                                        builder:
                                            (context, accountNumberController) {
                                          return TextFormField(
                                            controller: accountNumberController,
                                            focusNode: FocusNode(),
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Enter Account Number'),
                                            keyboardType: TextInputType.number,
                                          );
                                        },
                                      ),
                                      BlocSelector<TransferBloc, TransferState,
                                          TextEditingController?>(
                                        selector: (state) =>
                                            state.bankNameController,
                                        builder: (context, bankNameController) {
                                          return TextFormField(
                                            controller: bankNameController,
                                            focusNode: FocusNode(),
                                            decoration: const InputDecoration(
                                                labelText: 'Enter Bank Name'),
                                            keyboardType: TextInputType.text,
                                          );
                                        },
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          );
                        },
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
                        final state = context.read<TransferBloc>().state;
                        if (state.nameController?.text.isNotEmpty == true &&
                            state.amountController?.text.isNotEmpty == true &&
                            state.startDateController?.text.isNotEmpty ==
                                true &&
                            state.extractedtDateController?.text.isNotEmpty ==
                                true) {
                          final name = state.nameController?.text ?? '';
                          final amountString =
                              double.parse(state.amountController?.text ?? '') ;
                          final startDate =
                              state.startDateController?.text ?? '';
                          final expectedDate =
                              state.extractedtDateController?.text ?? '';
                          final bankName = state.bankNameController?.text ?? '';
                          final accountNum =
                              state.accountNumberController?.text ?? '';

                          // Parse the amount string to a double
                          final amount = amountString ?? 0.0;
                          final accountNumb =
                              double.tryParse(accountNum) ?? 0.0;

                          TransactionsModel transaction = TransactionsModel(
                            name: name,
                        amount: amount as double?,
                            type: 'عهدة',
                            status: 'pending',
                            date: startDate,
                            expectedDate: expectedDate,
                            id: "",
                            bankName: bankName,
                            accountNumber: accountNumb,
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
