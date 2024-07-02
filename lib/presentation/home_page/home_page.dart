import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:dsplus_finance/core/utils/logout.dart';
import 'package:dsplus_finance/presentation/home_page/models/transactions_model.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';

import '../home_page/widgets/homepage_item_widget.dart';
import 'bloc/home_bloc.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'widgets/my_drawer_widget.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static Widget builder() {
    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) =>  HomeBloc()
              ..add(HomeEvent())..add(GetUserData()),
          ),
          BlocProvider<UsersCubit>(
            create: (context) => UsersCubit(),
          ),
        ],

        child: HomePage());
  }

  @override
  Widget build(BuildContext context) {
    context.read<UsersCubit>()..currentUserRole();
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        print("////////////////////// ${state.currentUserRole}");
        if (state.status == UsersStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return (state.currentUserRole== "User")?Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          // Assign the key to the Scaffold

          appBar: CustomAppBar(
            height: getVerticalSize(60),
            leadingWidth: 59,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            centerTitle: false,
            title: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, left: 20, bottom: 12.0),
                  child: AppbarSubtitle(
                    text:
                    //  homePageItemModelObj?.type ??
                    "Welcome ${state.userModel?.name ?? ""}",
                  ),
                );
              },
            ),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // icon plus button
                PopupMenuButton<int>(
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                        value: 0,
                        child: CustomButton(
                            height: getVerticalSize(40),
                            width: getHorizontalSize(125),
                            text: "عهدة".tr,
                            variant: ButtonVariant.FillDeeppurple300,
                            padding: ButtonPadding.PaddingT10,
                            fontStyle: ButtonFontStyle.PoppinsMedium14,
                            prefixWidget: Container(
                                margin: getMargin(right: 9),
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgFrame244)),
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
                          fontStyle: ButtonFontStyle.PoppinsMedium14,
                          prefixWidget: Container(
                              margin: getMargin(right: 8),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgFrame245)),
                          onTap: () {
                            onTapAskForCash(context);
                          }),
                    ),
                  ],
                  icon: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
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
            ],
          ),

          drawer: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return MyDrawer(
                  name: state.userModel?.name ?? "",
                  imageUrl: state.userModel?.image ?? '',
                  parentContext: context);
            },
          ),

          //   ];
          // },

          body: Padding(
            padding: const EdgeInsets.only(top: 0),
            child:
            // NestedScrollView(
            //   headerSliverBuilder: (context, innerBox) {
            //     return [
            ////////// ///////////     //////////////////////////////////

            Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 21, right: 24),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                  ])),
                          SizedBox(height: getVerticalSize(15)),
                          BlocSelector<HomeBloc,
                              HomeState,
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
                                    : state.loading == true
                                    ? Center(
                                    child: CircularProgressIndicator())
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
                      );
                    },
                  ),
                )),
          ),
        ):Scaffold(
          appBar: AppBar(
            title: Text("Home Page"),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("You are not authorized to view this page"),
                ElevatedButton(
                  onPressed: () => logout(context),
                  child: const Text("Logout"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // onTapTransfer(BuildContext context) {
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
