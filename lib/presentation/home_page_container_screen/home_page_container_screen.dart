import '../ask_for_cash_screen/ask_for_cash_screen.dart';
import '../transfer_screen/transfer_screen.dart';
import 'bloc/home_page_container_bloc.dart';
import 'models/home_page_container_model.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/presentation/home_page/home_page.dart';
// import 'package:dsplus_finance/presentation/national_bank_page/national_bank_page.dart';
// import 'package:dsplus_finance/presentation/statistics_tab_container_page/statistics_tab_container_page.dart';
import 'package:dsplus_finance/widgets/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HomePageContainerScreen extends StatelessWidget {
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey();




  static Widget builder(BuildContext context) {
    return BlocProvider<HomePageContainerBloc>(
        create: (context) => HomePageContainerBloc(HomePageContainerState(
            homePageContainerModelObj: HomePageContainerModel()))
          ..add(HomePageContainerInitialEvent()),
        child: HomePageContainerScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageContainerBloc, HomePageContainerState>(
        builder: (context, state) {
      return SafeArea(
          child: Scaffold(
              backgroundColor: ColorConstant.whiteA700,
              body: Navigator(
                  // key: navigatorKey,
                  initialRoute: AppRoutes.homePage,
                  onGenerateRoute: (routeSetting) => PageRouteBuilder(
                      pageBuilder: (ctx, ani, ani1) =>
                          getCurrentPage(context, routeSetting.name!),
                      transitionDuration: Duration(seconds: 0))),
              // bottomNavigationBar:
              //     CustomBottomAppBar(onChanged: (BottomBarEnum type) {
                // Navigator.pushNamed(
                    // navigatorKey.currentContext!, getCurrentRoute(type)
                    //  );
              // }
              // ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked)
              );
    }
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Lock:
        return AppRoutes.homePage;
      case BottomBarEnum.CheckMarkGray500:
        return AppRoutes.statisticsTabContainerPage;
      // case BottomBarEnum.ComputerGray500:
      //   return AppRoutes.nationalBankPage;
      case BottomBarEnum.SearchGray5002:
        return "/";
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(
    BuildContext context,
    String currentRoute,
  ) {
    switch (currentRoute) {
      case AppRoutes.homePage:
        return HomePage.builder();
      // case AppRoutes.statisticsTabContainerPage:
      //   return StatisticsTabContainerPage.builder(context);
      // case AppRoutes.nationalBankPage:
      //   return NationalBankPage.builder(context);

      case AppRoutes.askForCashScreen:
        return AskForCashScreen.builder(context);
      case AppRoutes.transferScreen:
        return TransferScreen.builder(context);
      default:
        return DefaultWidget();
    }
  }
}
