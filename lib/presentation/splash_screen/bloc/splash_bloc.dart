import 'package:dsplus_finance/admin/home_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app/app_export.dart';
import 'package:dsplus_finance/presentation/splash_screen/models/splash_model.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(SplashState initialState) : super(initialState) {
    on<SplashInitialEvent>(_onInitialize);
  }

  _onInitialize(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    // addUserSharedPrefs({String? email, String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', email);
    // prefs.setString('password', password);

    String emailSaved = prefs.getString('email') ?? "";
    String roleSaved = prefs.getString('role') ?? "";

    // debugPrint(semail);
    // }
    final String? loggedInUserId = PrefUtils().getId();
    Future.delayed(const Duration(seconds: 3), () {
      if (
          // loggedInUserId?.isNotEmpty ?? false ||
          emailSaved.isNotEmpty) {
        debugPrint('id:$loggedInUserId');
        if (roleSaved == "Admin" || roleSaved == "SuperAdmin") {
          NavigatorService.popAndPushNamed(AppRoutes.adminHomePage);
        } else {
          NavigatorService.popAndPushNamed(AppRoutes.homePageContainerScreen);
        }
      } else {
        NavigatorService.popAndPushNamed(AppRoutes.loginPageTabContainerScreen);
      }
    });
  }
}
