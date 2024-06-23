import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ask_for_cash_screen/ask_for_cash_screen.dart';
import '../attachements/constants/colors.dart';
import '../attachements/models/banner.dart' as model;
import 'package:dsplus_finance/presentation/attachements/banner/controllers/banner_controller.dart';

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
      backgroundColor: AppColors.backgroundColor,
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
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: AppbarSubtitle(
            text:
                //  homePageItemModelObj?.type ??
                "تصفية",
          ),
        ),
      ),
      body: ListView(padding: EdgeInsets.all(16.0), children: [
        SizedBox(
          height: 30,
        ),
        Card(
          color: Colors.white,
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Your Balance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
        SizedBox(height: 10),

        Divider(
          color: Colors.grey.withOpacity(0.5), // Adjust color as needed
          height: 20,
        ),
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
                    NavigatorService.pushNamed(
                      AppRoutes.addBannerScreen,
                      arguments: homePageItemModelObj,
                    );
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
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final banner = snapshot.data?[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              scheme.primary.withOpacity(0.5),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            // color: Colors.grey.withOpacity(0.1),
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
                                              builder: (context) =>
                                                  FullScreenImage(
                                                      imageUrl:
                                                          banner?.imageUrl ??
                                                              ""),
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
                                                        banner?.imageUrl ?? "",
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Money: ${banner?.amount}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                Text(
                                                  "Desctription: ${banner?.description}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        // left: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: (banner?.status ==
                                                    "pending")
                                                ? Colors.amber
                                                : (banner?.status == "Approved")
                                                    ? Colors.green
                                                    : Colors.red,
                                            child: Text(
                                              "${banner?.status}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            radius: 25,
                                          ),
                                        )),
                                  ],
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

  onTapArrowleft5(BuildContext context) {
    NavigatorService.goBack();
  }

  onTapBtnArrowright(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.sendMoneyScreen,
    );
  }
}
