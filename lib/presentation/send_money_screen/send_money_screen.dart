import 'package:dsplus_finance/presentation/transfer_screen/bloc/transfer_bloc.dart';

import '../../widgets/custom_cardItem.dart';
import '../home_page/models/transactions_model.dart';

import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:dsplus_finance/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SendMoneyScreen extends StatelessWidget {
  static Widget builder(BuildContext context) {
    return BlocProvider<TransferBloc>(
        create: (context) => TransferBloc()..add(TransferEvent()),
        child: SendMoneyScreen());
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed data from the arguments
    final TransactionsModel transaction =
        ModalRoute.of(context)!.settings.arguments as TransactionsModel;
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
              height: getVerticalSize(49),
              leadingWidth: 59,
              leading: AppbarIconbutton(
                  svgPath: ImageConstant.imgArrowleftBlack900,
                  margin: getMargin(left: 24, top: 7, bottom: 7),
                  onTap: () {
                    onTapArrowleft1(context);
                  }),
              centerTitle: true,
              title: AppbarSubtitle(text: "Confirm Data".tr),
              // actions: [
              // AppbarIconbutton1(
              //     svgPath: ImageConstant.imgGlobe,
              //     margin: getMargin(left: 24, top: 7, right: 24, bottom: 7))
              // ]
            ),
            body: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                BuildCard(
                  title: 'Name',
                  value: transaction.name ?? "",
                ),
                transaction.accountNumber == 0
                    ? SizedBox()
                    : BuildCard(title: 'Date', value: transaction.date ?? ""),
                BuildCard(
                  title: 'Amount',
                  value: "${transaction.amount}",
                ),
                transaction.accountNumber == 0
                    ? SizedBox()
                    : BuildCard(
                        title: 'Expected Date',
                        value: transaction.expectedDate ?? ""),
                BuildCard(title: 'Status', value: transaction.status ?? ""),
                BuildCard(title: 'Type', value: transaction.type ?? ""),
                transaction.bankName?.isEmpty == true
                    ? BuildCard(title: 'Receiving Money By', value: 'Cash')
                    : BuildCard(title: 'Receiving Money By', value: "Credit"),
                // transaction.accountNumber == 0
                //     ? SizedBox()
                //     : BuildCard(
                //         title: 'Account Number',
                //         value: "${transaction.accountNumber}"),
                transaction.attachments?.length == 0 ||
                        transaction.attachments?.length.toString() == null
                    ? SizedBox()
                    : BuildCard(
                        title: 'Attachments',
                        value:
                            transaction.attachments?.length.toString() ?? ''),
              ],
            ),
            bottomNavigationBar: CustomButton(
                onTap: () async {
                  await context
                      .read<TransferBloc>()
                      .uploadFilesAndUpdateTransaction(transaction);
                  NavigatorService.pushNamedAndRemoveUntil(
                    AppRoutes.homePageContainerScreen,
                    arguments:
                        transaction, // Pass the transaction object as an argument
                  );
                },
                height: getVerticalSize(50),
                text: "Send Request".tr,
                margin: getMargin(left: 24, right: 24, bottom: 36))));
  }

  onTapArrowleft1(BuildContext context) {
    NavigatorService.goBack();
  }
}
