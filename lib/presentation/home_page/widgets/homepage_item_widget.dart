import 'package:dsplus_finance/presentation/home_page/models/transactions_model.dart';

import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePageItemWidget extends StatelessWidget {
  HomePageItemWidget(this.homePageItemModelObj);

  TransactionsModel homePageItemModelObj;
  @override
  Widget build(BuildContext context) {
    bool isEditable = false;

    return GestureDetector(
      onTap: () {
        if (homePageItemModelObj.status == 'pending') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.yellow,
              content: Text(
                'Request is still pending. Waiting for approval.',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        } else {
          // Execute onTapBtn function
          onTapBtn(context, homePageItemModelObj);
        }

        // final isditable = homePageItemModelObj.status == 'Approved'
        //     ? !isEditable
        //     : isEditable;

        // if (isditable) {
        //   onTapBtn(context, homePageItemModelObj);

        // }
      },

      // home cards
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomIconButton(
                  height: 100,
                  width: 100,
                  variant: IconButtonVariant.FillGray100,
                  shape: IconButtonShape.RoundedBorder13,
                  padding: IconButtonPadding.PaddingAll15,
                  child: homePageItemModelObj.type == 'عهدة'
                      ? Image(image: AssetImage('assets/images/1.png'))
                      : Image(image: AssetImage('assets/images/2.png'))
                  //  CustomImageView(
                  //   svgPath: ImageConstant.imgFire,
                  // ),
                  ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homePageItemModelObj.name ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      homePageItemModelObj.amount?.toString() ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Text(
                homePageItemModelObj.expectedDate ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        color: (homePageItemModelObj.status == 'pending')
            ? Colors.yellow
            : (homePageItemModelObj.status == 'Approved')
                ? Colors.green
                : Colors.red,
      ),
    );
  }

  void onTapBtn(BuildContext context, TransactionsModel transaction) {
    NavigatorService.pushNamed(
      AppRoutes.detailsPage,
      arguments: transaction, // Pass the transaction object as an argument
    );
  }
}
