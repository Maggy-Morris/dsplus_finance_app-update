import 'package:dsplus_finance/widgets/custom_cardItem.dart';
import 'package:dsplus_finance/widgets/fullscreenImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/navigator_service.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/app_bar/appbar_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

import '../home_page/models/transactions_model.dart';
import 'bloc/details_bloc.dart';
import 'models/details_model.dart';

class DetailsPage extends StatelessWidget {
  TransactionsModel? homePageItemModelObj;

  // DetailsPage();

  DetailsPage();
  static Widget builder(BuildContext context) {
    return BlocProvider<DetailsBloc>(
        create: (context) =>
            DetailsBloc(DetailsState(detailsModelObj: DetailsModel()))
              ..add(DetailsEvent()),
        child: DetailsPage());
  }

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
        actions: [
          homePageItemModelObj.type == 'عهدة' &&
                  homePageItemModelObj.status == 'Approved'
              ? AppbarIconbutton(
                  svgPath: ImageConstant.imgPlus,
                  margin: getMargin(left: 24, top: 7, right: 24, bottom: 7),
                  onTap: () {
                    Navigator.pushNamed(
                      context, '/settlementPage',
                      arguments:
                          homePageItemModelObj, // Pass the transaction object as an argument
                    );
                  })
              : SizedBox(),
        ],
        centerTitle: true,
        title: AppbarSubtitle(text: homePageItemModelObj.type ?? ""),
      ),
      body: homePageItemModelObj.status == 'Approved'
          ? ListView(padding: EdgeInsets.all(16.0), children: [
              BuildCard(title: "Name", value: homePageItemModelObj.name ?? ''),
              BuildCard(
                  title: 'Amount',
                  value: homePageItemModelObj.amount?.toString() ?? ""),
              BuildCard(title: "Date", value: homePageItemModelObj.date ?? ""),
              homePageItemModelObj.expectedDate == ""
                  ? BuildCard(
                      title: 'Expected Date',
                      value: homePageItemModelObj.expectedDate ?? "")
                  : SizedBox(),
              BuildCard(
                  title: 'status', value: homePageItemModelObj.status ?? ""),
              BuildCard(title: 'type', value: homePageItemModelObj.type ?? ""),
              homePageItemModelObj.bankName?.isEmpty == true
                  ? BuildCard(title: 'Receiving Money By', value: 'Cash')
                  : BuildCard(title: 'Receiving Money By', value: "Credit"),
              // homePageItemModelObj.accountNumber == 0
              //     ? SizedBox()
              //     : BuildCard(
              //         title: 'Account Number',
              //         value: homePageItemModelObj.accountNumber.toString(),
              //       ),
              homePageItemModelObj.attachments?.length == 0
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageList(
                              imageUrlList:
                                  (homePageItemModelObj.attachments ?? [])
                                      .cast<String>(),
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: BuildCard(
                              title: 'Attachments',
                              value: homePageItemModelObj.attachments?.length
                                      .toString() ??
                                  '',
                            ),
                          ),
                          Positioned(
                            bottom: 12.0,
                            right: 10.0,
                            child: Text(
                              'View Attachments',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ])
          : ListView(padding: EdgeInsets.all(16.0), children: [
              BuildCard(
                  title: 'status', value: homePageItemModelObj.status ?? ""),
              BuildCard(
                  title: 'Reason of Rejection',
                  value: homePageItemModelObj.reason ?? ""),
            ]),
    );
  }

  onTapArrowleft5(BuildContext context) {
    NavigatorService.goBack();
  }
}
