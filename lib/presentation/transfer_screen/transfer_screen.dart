import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;

import '../home_page/models/transactions_model.dart';
import 'bloc/transfer_bloc.dart';
import 'models/transfer_model.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:dsplus_finance/widgets/custom_icon_button.dart';
import 'package:dsplus_finance/widgets/custom_image_view.dart';

class TransferScreen extends StatelessWidget {
  final TransactionsModel transactionsModel = TransactionsModel();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Widget builder(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransferBloc>(
          create: (context) => TransferBloc()..add(TransferEvent()),
          child: TransferScreen(),
        ),
      ],
      child: TransferScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(builder: (context, state) {
      return SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
              height: getVerticalSize(50),
              leadingWidth: 59,
              leading: AppbarIconbutton(
                svgPath: ImageConstant.imgArrowleftBlack900,
                margin: getMargin(left: 24, top: 8, bottom: 7),
                onTap: () {
                  Navigator.pushNamed(context, '/home_page');
                },
              ),
              centerTitle: true,
              title: AppbarSubtitle(text: "عهدة".tr),
            ),
            body: SingleChildScrollView(
              padding: getPadding(left: 24, right: 24, top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: getMargin(bottom: 28),
                    padding: getPadding(
                      left: 44,
                      top: 49,
                      right: 44,
                      bottom: 49,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: fs.Svg(ImageConstant.imgGroup199),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          svgPath: ImageConstant.imgVolume23x36,
                          height: getVerticalSize(23),
                          width: getHorizontalSize(36),
                          margin: getMargin(bottom: 18),
                        ),
                        Spacer(),
                        Text(
                          "lbl_4023".tr,
                          style: AppStyle.txtPoppinsMedium10,
                        ),
                        Padding(
                          padding: getPadding(left: 8),
                          child: Text(
                            "lbl_5534".tr,
                            style: AppStyle.txtPoppinsMedium10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildTextFormField(
                    context,
                    state,
                    'Name',
                    Icons.person,
                    TextInputType.name,
                    (value) {
                      context.read<TransferBloc>().add(EditName(name: value));
                      context
                          .read<TransferBloc>()
                          .add(EditUserName(userName: state.userName));
                    },
                  ),
                  SizedBox(height: 16),
                  buildTextFormField(
                    context,
                    state,
                    'Money',
                    Icons.monetization_on_sharp,
                    TextInputType.number,
                    (value) {
                      context.read<TransferBloc>().add(
                          EditAmount(amount: double.tryParse(value) ?? 0.0));
                    },
                  ),
                  SizedBox(height: 16),
                  buildDateFormField(
                    context,
                    state,
                    'Start Date(dd/mm/yyyy)',
                    Icons.date_range_outlined,
                    state.startDateString,
                    (pickedDate) {
                      if (pickedDate != null) {
                        context.read<TransferBloc>().add(EditStartDateString(
                              startDateString:
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                            ));
                        context
                            .read<TransferBloc>()
                            .add(EditStartDate(startDate: pickedDate));
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  buildDateFormField(
                    context,
                    state,
                    'Expected Date(dd/mm/yyyy)',
                    Icons.date_range_outlined,
                    state.expectedDateString,
                    (pickedDate) {
                      if (pickedDate != null) {
                        context.read<TransferBloc>().add(ExpectedDateString(
                              expectedDateString:
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                            ));
                        context
                            .read<TransferBloc>()
                            .add(ExpectedDate(expectedDate: pickedDate));
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  buildRadioOptions(context, state),
                  SizedBox(height: 40),
                  Center(
                    child: CustomIconButton(
                      height: 70,
                      width: 70,
                      margin: getMargin(bottom: 5),
                      variant: IconButtonVariant.OutlineBlueA70066,
                      shape: IconButtonShape.CircleBorder35,
                      padding: IconButtonPadding.PaddingAll23,
                      onTap: () async {
                        if (state.name?.isNotEmpty == true &&
                            state.amount != 0 &&
                            state.startDateString?.isNotEmpty == true &&
                            state.expectedDateString?.isNotEmpty == true) {
                          TransactionsModel transaction = TransactionsModel(
                            email: firebaseAuth.currentUser?.email ?? "",
                            userName: state.userName,
                            name: state.name,
                            amount: state.amount,
                            userId: firebaseAuth.currentUser?.uid,
                            type: 'عهدة',
                            status: 'pending',
                            date: state.startDateString,
                            expectedDate: state.expectedDateString,
                            id: "",
                            cashOrCredit: state.selectedOption == "cash",
                            bankName: state.bankName,
                            accountNumber: state.accountNumber,
                          );

                          onTapBtnArrowright(context, transaction);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields.')),
                          );
                        }
                      },
                      child:
                          CustomImageView(svgPath: ImageConstant.imgArrowright),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildTextFormField(
    BuildContext context,
    TransferState state,
    String labelText,
    IconData icon,
    TextInputType keyboardType,
    Function(String) onChanged,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Widget buildDateFormField(
    BuildContext context,
    TransferState state,
    String labelText,
    IconData icon,
    String? initialText,
    Function(DateTime?) onDatePicked,
  ) {
    return TextFormField(
      controller: TextEditingController(text: initialText),
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        onDatePicked(pickedDate);
      },
    );
  }

  Widget buildRadioOptions(BuildContext context, TransferState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile(
          title: Text('Cash'),
          value: 'cash',
          groupValue: state.selectedOption,
          onChanged: (value) {
            context.read<TransferBloc>().add(
                  RadioButtonChanged(
                    selectedOption: value ?? "",
                    showTextField: false,
                  ),
                );
          },
        ),
        RadioListTile(
          title: Text('Credit'),
          value: 'credit',
          groupValue: state.selectedOption,
          onChanged: (value) {
            context.read<TransferBloc>().add(
                  RadioButtonChanged(
                    selectedOption: value ?? "",
                    showTextField: true,
                  ),
                );
          },
        ),
        if (state.showTextField == true)
          Column(
            children: [
              buildTextFormField(
                context,
                state,
                'Enter Account Number',
                Icons.account_balance,
                TextInputType.number,
                (value) {
                  context
                      .read<TransferBloc>()
                      .add(AccountNumber(accountNumber: int.parse(value)));
                },
              ),
              SizedBox(height: 16),
              buildTextFormField(
                context,
                state,
                'Enter Bank Name',
                Icons.account_balance_outlined,
                TextInputType.text,
                (value) {
                  context.read<TransferBloc>().add(BankName(bankName: value));
                },
              ),
            ],
          ),
      ],
    );
  }

  void onTapBtnArrowright(BuildContext context, TransactionsModel transaction) {
    NavigatorService.pushNamed(
      AppRoutes.sendMoneyScreen,
      arguments: transaction,
    );
  }
}
