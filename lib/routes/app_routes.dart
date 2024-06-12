import 'package:dsplus_finance/presentation/Settlement_of_accounts/settlement_of_accounts_screen.dart';
import 'package:flutter/material.dart';
import 'package:dsplus_finance/presentation/splash_screen/splash_screen.dart';
import 'package:dsplus_finance/presentation/login_page_tab_container_screen/login_page_tab_container_screen.dart';
import 'package:dsplus_finance/presentation/home_page_container_screen/home_page_container_screen.dart';
import 'package:dsplus_finance/presentation/transfer_screen/transfer_screen.dart';
import 'package:dsplus_finance/presentation/send_money_screen/send_money_screen.dart';
import 'package:dsplus_finance/presentation/confirmation_screen/confirmation_screen.dart';
import 'package:dsplus_finance/presentation/transfer_request_screen/transfer_request_screen.dart';
import 'package:dsplus_finance/presentation/history_screen/history_screen.dart';
import 'package:dsplus_finance/presentation/profile_screen/profile_screen.dart';
import 'package:dsplus_finance/presentation/settings_screen/settings_screen.dart';
import 'package:dsplus_finance/presentation/app_navigation_screen/app_navigation_screen.dart';

// import '../admin/login_page_second.dart';
import '../admin/home_page.dart';
import '../presentation/ask_for_cash_screen/ask_for_cash_screen.dart';
import '../presentation/attachements/banner/screens/add_banner_screen.dart';
import '../presentation/details_page/details_page.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String loginPage = '/login_page';

  static const String loginPageTabContainerScreen =
      '/login_page_tab_container_screen';

  static const String adminHomePage = '/admin-home-page';


  static const String addBannerScreen = '/add-banner-screen';

  static const String signUpPage = '/sign_up_page';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String verifyEmailScreen = '/verify_email_screen';

  static const String countryOrRegionScreen = '/country_or_region_screen';

  static const String homePage = '/home_page';

  static const String homePageContainerScreen = '/home_page_container_screen';

  static const String transferScreen = '/transfer_screen';
  static const String askForCashScreen = '/ask_for_cash_screen';

  static const String detailsPage = '/details_page';

  static const String settlementPage = '/settlementPage';

  static const String sendMoneyScreen = '/send_money_screen';

  // static const String statisticsPage = '/statistics_page';

  static const String statisticsTabContainerPage =
      '/statistics_tab_container_page';

  static const String currencyExchangeScreen = '/currency_exchange_screen';

  static const String transferAmountScreen = '/transfer_amount_screen';

  static const String confirmationScreen = '/confirmation_screen';

  static const String transferRequestScreen = '/transfer_request_screen';

  static const String historyScreen = '/history_screen';
  static const String loginPageSecond = '/login_page_second';

  // static const String nationalBankPage = '/national_bank_page';

  static const String atmLocationScreen = '/atm_location_screen';

  static const String profileScreen = '/profile_screen';

  static const String settingsScreen = '/settings_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        // loginPageSecond:LoginPageSecond.builder,
        adminHomePage : AdminHomePage.builder,
        addBannerScreen: AddBannerScreen.builder,
        splashScreen: SplashScreen.builder,
        detailsPage: DetailsPage.builder,
        settlementPage: SettlementOfAccountsScreen.builder,
        loginPageTabContainerScreen: LoginPageTabContainerScreen.builder,
        homePageContainerScreen: HomePageContainerScreen.builder,
        transferScreen: TransferScreen.builder,
        askForCashScreen: AskForCashScreen.builder,
        sendMoneyScreen: SendMoneyScreen.builder,
        confirmationScreen: ConfirmationScreen.builder,
        transferRequestScreen: TransferRequestScreen.builder,
        historyScreen: HistoryScreen.builder,
        profileScreen: ProfileScreen.builder,
        settingsScreen: SettingsScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: SplashScreen.builder
      };
}
