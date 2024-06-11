import 'package:dsplus_finance/presentation/home_page/models/transactions_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home_page/widgets/homepage_item_widget.dart';
import 'bloc/home_bloc.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static Widget builder() {
    return BlocProvider<HomeBloc>(
        create: (context) => HomeBloc()..add(HomeEvent()), child: HomePage());
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.loginPageTabContainerScreen

          //  MaterialPageRoute(
          //    builder: (context) => loginPageTabContainerScreen(),
          //  ),
          );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // String userName = PostRegisterReq().name ?? "";
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            // appBar:
            body: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBox) {
                  return [
                    ////////// ///////////     //////////////////////////////////
                    SliverAppBar(
                      backgroundColor: ColorConstant.whiteA700,
                      leading: Container(
                        width: 0,
                      ),
                      title: Container(
                          width: getHorizontalSize(200),
                          margin: getMargin(left: 24),
                          child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Welcome To DS Finanace".tr,
                                    style: TextStyle(
                                        color: ColorConstant.black900,
                                        fontSize: getFontSize(20),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600)),
                                // TextSpan(
                                //     text: "Welcome".tr,
                                //     style: TextStyle(
                                //         color: ColorConstant.gray500,
                                //         fontSize: getFontSize(14),
                                //         fontFamily: 'Poppins',
                                //         fontWeight: FontWeight.w500))
                              ]),
                              textAlign: TextAlign.left)),
                      leadingWidth: 0,
                      floating: false,
                      pinned: true,
                      actions: [
                        IconButton(
                          onPressed: () {
                            logout(context);
                          },
                          icon: Icon(Icons.logout),
                        ),
                        // CustomImageView(
                        //     imagePath: ImageConstant.imgEllipse30840x40,
                        //     height: getSize(40),
                        //     width: getSize(40),
                        //     radius:
                        //         BorderRadius.circular(getHorizontalSize(20)),
                        //     margin: getMargin(
                        //         left: 24, top: 6, right: 24, bottom: 6))
                      ],
                    ),
                  ];
                },
                body: Container(
                    width: double.maxFinite,
                    padding: getPadding(left: 24, top: 21, right: 24),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // CustomButton(
                                //     height: getVerticalSize(40),
                                //     width: getHorizontalSize(125),
                                //     text: "lbl_request".tr,
                                //     variant: ButtonVariant.FillTeal300,
                                //     padding: ButtonPadding.PaddingT10,
                                //     fontStyle: ButtonFontStyle.PoppinsMedium14,
                                //     prefixWidget: Container(
                                //         margin: getMargin(right: 8),
                                //         child: CustomImageView(
                                //             svgPath:
                                //                 ImageConstant.imgFrame243)),
                                //     onTap: () {
                                //       onTapRequest(context);
                                //     }),

                                // icon plus button
                                PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 0,
                                        child: CustomButton(
                                            height: getVerticalSize(40),
                                            width: getHorizontalSize(125),
                                            text: "عهدة".tr,
                                            variant:
                                                ButtonVariant.FillDeeppurple300,
                                            padding: ButtonPadding.PaddingT10,
                                            fontStyle:
                                                ButtonFontStyle.PoppinsMedium14,
                                            prefixWidget: Container(
                                                margin: getMargin(right: 9),
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgFrame244)),
                                            onTap: () {
                                              onTapTransfer(context);
                                            })),
                                    PopupMenuItem(
                                      value: 1,
                                      child: CustomButton(
                                          height: getVerticalSize(40),
                                          width: getHorizontalSize(125),
                                          text: "اذن صرف".tr,
                                          variant: ButtonVariant.FillTeal300,
                                          padding: ButtonPadding.PaddingT10,
                                          fontStyle:
                                              ButtonFontStyle.PoppinsMedium14,
                                          prefixWidget: Container(
                                              margin: getMargin(right: 8),
                                              child: CustomImageView(
                                                  svgPath: ImageConstant
                                                      .imgFrame245)),
                                          onTap: () {
                                            onTapAskForCash(context);
                                          }),
                                    ),
                                  ],
                                  icon: Icon(Icons.add),
                                  onSelected: (value) {
                                    // Handle the selection of the menu item
                                    if (value == 0) {
                                      onTapTransfer(context);

                                      // Perform action for the first button
                                    } else if (value == 1) {
                                      onTapAskForCash(context);

                                      // Perform action for the second button
                                    }
                                  },
                                ),

//////////////////////////////////////////////////////////////////
                              ]),
                          Padding(
                              padding: getPadding(top: 23),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("lbl_transfer_history".tr,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPoppinsSemiBold18),
                                    // Padding(
                                    //     padding: getPadding(top: 5, bottom: 3),
                                    //     child: Text("lbl_see_all".tr,
                                    //         overflow: TextOverflow.ellipsis,
                                    //         textAlign: TextAlign.left,
                                    //         style: AppStyle.txtPoppinsMedium12))
                                  ])),
                          SizedBox(height: getVerticalSize(15)),
                          BlocSelector<HomeBloc, HomeState,
                                  List<TransactionsModel>?>(
                              selector: (state) => state.allTransactions,
                              builder: (context, transactions) {
                                return transactions?.length != 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 36),
                                        child: ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                  height: getVerticalSize(15));
                                            },
                                            itemCount:
                                                transactions?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              // HomePageItemModel model = homeModelObj
                                              //         ?.homePageItemList[index] ??
                                              //     HomePageItemModel();
                                              return HomePageItemWidget(
                                                  transactions?[index] ??
                                                      TransactionsModel());
                                            }),
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Image.asset(
                                              "assets/images/money.png"),
                                        ],
                                      );
                              })
                        ],
                      ),
                    )),
              ),
            )));
  }

  // onTapTransfer(BuildContext context) {
  //   NavigatorService.pushNamed(
  //     AppRoutes.transferScreen,
  //   );
  // }

  onTapTransfer(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.transferScreen);
  }

  onTapAskForCash(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.askForCashScreen);
    // NavigatorService.pushNamed(
    //   AppRoutes.askForCashScreen,
    // );
  }

  onTapRequest(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.transferRequestScreen,
    );
  }
}
